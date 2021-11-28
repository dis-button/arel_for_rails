class CommonTableExpressions::OrderArticles
  class << self
    def call
      # lets define new arel table
      longest_comments_cte = Arel::Table.new(:longest_comments)

      # lets define function to calculate comments length
      comment_length_function = Arel::Nodes::NamedFunction.new('length', [Comment.arel_table[:content]])
      # comment_length_function.to_sql is:
      #   length("comments"."content")

      # lets define new sql window function that can be used for getting correct row number
      longest_comment_window_function = Arel::Nodes::Window.new.
        partition(Comment.arel_table[:article_id]).
        order(comment_length_function.desc)
      # longest_comment_window_function.to_sql is:
      #   (PARTITION BY "comments"."article_id" ORDER BY length("comments"."content") DESC)

      # lets define row number function over our window function
      longest_comment_rank_function = Arel::Nodes::NamedFunction.
        new('row_number', []).
        over(longest_comment_window_function)
      # longest_comment_rank_function.to_sql is:
      #   row_number() OVER (PARTITION BY "comments"."article_id" ORDER BY length("comments"."content") DESC)

      # lets define the CTE content
      longest_comments_select = Comment.arel_table.project(
        Comment.arel_table[:article_id],
        comment_length_function.as('comment_length'),
        longest_comment_rank_function.eq(1).as('is_longest_comment')
      )
      # longest_comments_select.to_sql is:
      #   SELECT
      #     "comments"."article_id",
      #     length("comments"."content") AS comment_length,
      #     row_number() OVER (PARTITION BY "comments"."article_id" ORDER BY length("comments"."content") AS comment_length DESC) = 1 AS is_longest_comment
      #   FROM "comments"


      # lets define the CTE itself
      composed_longest_comments_cte = Arel::Nodes::As.new(
        longest_comments_select,
        longest_comments_cte
      )
      # longest_comments_select.to_sql is:
      #   (
      #     SELECT
      #       "comments"."article_id",
      #       length("comments"."content") AS comment_length,
      #       row_number() OVER (PARTITION BY "comments"."article_id" ORDER BY length("comments"."content") AS comment_length DESC) = 1 AS is_longest_comment
      #     FROM "comments"
      #   ) AS "longest_comments"

      # lets define the way articles will be joined to CTE
      join_longest_comments_cte = Article.arel_table.join(longest_comments_cte).on(
        Article.arel_table[:id].
          eq(longest_comments_cte[:article_id]).
          and(longest_comments_cte[:is_longest_comment])
      ).join_sources
      # join_longest_comments_cte.last.to_sql (this is array with one value) is:
      #  INNER JOIN "longest_comments" ON "articles"."id" = "longest_comments"."article_id" AND "longest_comments"."is_longest_comment"

      # lets order articles with longes comment
      Article.
        with(composed_longest_comments_cte). #this does not work. why?
        joins(join_longest_comments_cte).
        order(longest_comments_cte[:comment_length].desc, Article.arel_table[:created_at].desc)
    end
  end
end
