class CommonTableExpressions::ArticleWithLongestCommentChain
  class << self
    def call
      # lets define new arel tables
      # comment_chain - this will recursively help us determine the longest comment chain
      comment_chain_table = Arel::Table.new(:comment_chain)
      # article_max_chain_statistics - this will get max from comment_chain collection
      article_max_chain_statistics_table = Arel::Table.new(:article_max_chain_statistics)
      # article_thread_count - this will count all of the zero level comments - thread starts
      article_thread_count_table = Arel::Table.new(:article_thread_count)

      comment_chain_base_select = Comment.arel_table.project(
          Comment.arel_table[:id].as('super_parent_id'),
          Comment.arel_table[:id].as('id'),
          Comment.arel_table[:article_id].as('article_id'),
          Arel::Nodes::SqlLiteral.new('1::bigint').as('thread_length')
        ).where(Comment.arel_table[:parent_id].not_eq(nil))
      # puts comment_chain_base_select.to_sql
      # SELECT
      #   "comments"."id" AS super_parent_id,
      #   "comments"."id" AS id,
      #   "comments"."article_id" AS article_id,
      #   1::bigint AS thread_length
      # FROM "comments"
      # WHERE "comments"."parent_id" IS NOT NULL

      comment_chain_recursive_select = Comment.arel_table.project(
        comment_chain_table[:super_parent_id].as('super_parent_id'),
        Comment.arel_table[:id].as('id'),
        Comment.arel_table[:article_id].as('article_id'),
        Arel::Nodes::Addition.new(comment_chain_table[:super_parent_id], Arel::Nodes::SqlLiteral.new('1::bigint')).as('thread_length')
      ).join(comment_chain_table).on(comment_chain_table[:id].eq(Comment.arel_table[:parent_id]))
      # puts comment_chain_recursive_select.to_sql
      # SELECT
      #   "comment_chain"."super_parent_id" AS super_parent_id,
      #   "comments"."id" AS id,
      #   "comments"."article_id" AS article_id,
      #   "comment_chain"."super_parent_id" + 1::bigint AS thread_length
      # FROM "comments"
      # INNER JOIN "comment_chain"
      #   ON "comment_chain"."id" = "comments"."parent_id"

      comment_chain_cte = Arel::Nodes::As.new(
        comment_chain_table,
        Arel::Nodes::UnionAll.new(comment_chain_base_select, comment_chain_recursive_select)
      )
      # puts comment_chain_cte.to_sql
      # "comment_chain" AS (
      #   (
      #     SELECT
      #       "comments"."id" AS super_parent_id,
      #       "comments"."id" AS id,
      #       "comments"."article_id" AS article_id,
      #       1::bigint AS thread_length
      #     FROM "comments"
      #     WHERE "comments"."parent_id" IS NOT NULL
      #   ) UNION ALL (
      #     SELECT
      #       "comment_chain"."super_parent_id" AS super_parent_id,
      #       "comments"."id" AS id,
      #       "comments"."article_id" AS article_id,
      #       "comment_chain"."super_parent_id" + 1::bigint AS thread_length
      #     FROM "comments"
      #     INNER JOIN "comment_chain"
      #       ON "comment_chain"."id" = "comments"."parent_id"
      #   )
      # )

      article_max_chain_statistics_select = comment_chain_table.project(
        comment_chain_table[:thread_length].maximum.as('max_thread_length'),
        comment_chain_table[:article_id].as('article_id')
      ).group(comment_chain_table[:article_id])
      # article_max_chain_statistics_select.to_sql
      # SELECT
      #   MAX("comment_chain"."thread_length") AS max_thread_length,
      #   "comment_chain"."article_id" AS article_id
      # FROM "comment_chain"
      # GROUP BY "comment_chain"."article_id"

      article_max_chain_statistics_cte = Arel::Nodes::As.new(
        article_max_chain_statistics_table,
        article_max_chain_statistics_select
      )
      # puts article_max_chain_statistics_cte.to_sql
      # "article_max_chain_statistics" AS (
      #   SELECT
      #     MAX("comment_chain"."thread_length") AS max_thread_length,
      #     "comment_chain"."article_id" AS article_id
      #   FROM "comment_chain"
      #   GROUP BY "comment_chain"."article_id"
      # )

      article_thread_count_select = Comment.arel_table.project(
        Arel::Nodes::SqlLiteral.new('1').count.as('thread_count'),
        Comment.arel_table[:article_id].as('article_id')
      ).where(Comment.arel_table[:parent_id].eq(nil)).group(Comment.arel_table[:article_id])
      # puts article_thread_count_select.to_sql
      # SELECT
      #   COUNT(1) AS thread_count,
      #   "comments"."article_id" AS article_id
      # FROM "comments"
      # WHERE "comments"."parent_id" IS NULL
      # GROUP BY "comments"."article_id"

      article_thread_count_cte = Arel::Nodes::As.new(
        article_thread_count_table,
        article_thread_count_select
      )
      # puts article_thread_count_cte.to_sql
      # "article_thread_count" AS (
      #   SELECT
      #     COUNT(1) AS thread_count,
      #     "comments"."article_id" AS article_id
      #   FROM "comments"
      #   WHERE "comments"."parent_id" IS NULL
      #   GROUP BY "comments"."article_id"
      # )

      sql_statement = Article.arel_table.
        project(
          Article.arel_table[Arel.star],
          Arel::Nodes::Multiplication.new(
            article_max_chain_statistics_table[:max_thread_length],
            article_thread_count_table[:thread_count]
          ).as('article_score')
        ).
        join(article_max_chain_statistics_table).on(article_max_chain_statistics_table[:article_id].eq(Article.arel_table[:id])).
        join(article_thread_count_table).on(article_thread_count_table[:article_id].eq(Article.arel_table[:id])).
        with(:recursive, comment_chain_cte, article_max_chain_statistics_cte, article_thread_count_cte)
      # puts sql_statement.to_sql
      # WITH RECURSIVE "comment_chain" AS (
      #   (
      #     SELECT
      #       "comments"."id" AS super_parent_id,
      #       "comments"."id" AS id,
      #       "comments"."article_id" AS article_id,
      #       1::bigint AS thread_length
      #     FROM
      #       "comments"
      #     WHERE
      #       "comments"."parent_id" IS NOT NULL
      #   )
      #   UNION ALL (
      #     SELECT
      #       "comment_chain"."super_parent_id" AS super_parent_id,
      #       "comments"."id" AS id,
      #       "comments"."article_id" AS article_id,
      #       "comment_chain"."super_parent_id" + 1::bigint AS thread_length
      #     FROM
      #       "comments"
      #       INNER JOIN "comment_chain" ON "comment_chain"."id" = "comments"."parent_id"
      #   )
      # ),
      # "article_max_chain_statistics" AS (
      #   SELECT
      #     MAX("comment_chain"."thread_length") AS max_thread_length,
      #     "comment_chain"."article_id" AS article_id
      #   FROM
      #     "comment_chain"
      #   GROUP BY
      #     "comment_chain"."article_id"
      # ),
      # "article_thread_count" AS (
      #   SELECT
      #     COUNT(1) AS thread_count,
      #     "comments"."article_id" AS article_id
      #   FROM
      #     "comments"
      #   WHERE
      #     "comments"."parent_id" IS NULL
      #   GROUP BY
      #     "comments"."article_id"
      # )
      # SELECT
      #   "articles".*,
      #   "article_max_chain_statistics"."max_thread_length" * "article_thread_count"."thread_count" AS article_score
      # FROM
      #   "articles"
      #   INNER JOIN "article_max_chain_statistics" ON "article_max_chain_statistics"."article_id" = "articles"."id"
      #   INNER JOIN "article_thread_count" ON "article_thread_count"."article_id" = "articles"."id"

      Article.find_by_sql(sql_statement)
    end
  end
end
