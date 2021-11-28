class OrStatements::ArticlesByTitleOrCreationTime
  class << self
    def call
      Article.where(
        Article.arel_table[:subject].matches('%arel%').
          or(Article.arel_table[:created_at].lteq(DateTime.current - 1.day))
      )
    end
  end
end
