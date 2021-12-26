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
        order(Arel::Nodes::NamedFunction.new('length', [Comment.arel_table[:content]]).desc)
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
      #     row_number() OVER (PARTITION BY "comments"."article_id" ORDER BY length("comments"."content") DESC) = 1 AS is_longest_comment
      #   FROM "comments"

      # lets define the CTE itself
      composed_longest_comments_cte = Arel::Nodes::As.new(
        longest_comments_cte,
        longest_comments_select
      )
      # longest_comments_select.to_sql is:
      # "longest_comments" AS (
      #   SELECT
      #     "comments"."article_id",
      #     length("comments"."content") AS comment_length,
      #     row_number() OVER (PARTITION BY "comments"."article_id" ORDER BY length("comments"."content") DESC) = 1 AS is_longest_comment
      #   FROM "comments"
      # )

      # define our joining conditions
      join_conditions = Article.arel_table[:id].
        eq(longest_comments_cte[:article_id]).
        and(longest_comments_cte[:is_longest_comment])
      # join_conditions.to_sql is:
      # "articles"."id" = "longest_comments"."article_id" AND "longest_comments"."is_longest_comment"

      # lets define the way articles will be joined to CTE
      sql_statement = Article.arel_table.
        project(Article.arel_table[Arel.star], longest_comments_cte[:comment_length]).
        join(longest_comments_cte).
        on(join_conditions).
        order(longest_comments_cte[:comment_length].desc, Article.arel_table[:created_at].desc).
        with(composed_longest_comments_cte)
      # sql_statement.to_sql is:
      # WITH "longest_comments" AS (
      #   SELECT
      #     "comments"."article_id",
      #     length("comments"."content") AS comment_length,
      #     row_number() OVER (
      #       PARTITION BY "comments"."article_id"
      #       ORDER BY
      #         length("comments"."content") DESC
      #     ) = 1 AS is_longest_comment
      #   FROM
      #     "comments"
      # )
      # SELECT
      #   "articles".*,
      #   "longest_comments"."comment_length"
      # FROM "articles"
      # INNER JOIN "longest_comments"
      #   ON "articles"."id" = "longest_comments"."article_id"
      #   AND "longest_comments"."is_longest_comment"
      # ORDER BY
      #   "longest_comments"."comment_length" DESC,
      #   "articles"."created_at" DESC

      Article.find_by_sql(sql_statement)
      # this finds all articles with their longest comment
      # pp Article.find_by_sql(sql_statement).map { |a| [a.subject, a.comment_length].join(": ") }:
      # ["Pills - do not take them!: 43",
      #   "Arel is great: 26",
      #   "Charge (1854): 20",
      #   "The City of Sleep (1895): 20",
      #   "If - (1910): 20"]
    end
  end
end
