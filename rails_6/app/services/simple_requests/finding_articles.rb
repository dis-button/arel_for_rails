class SimpleRequests::FindingArticles
  class << self
    def call
      Article.
        where(Article.arel_table[:subject].matches('%arel%')).
        where(Article.arel_table[:created_at].lteq(DateTime.current - 1.day))
    end
  end
end
