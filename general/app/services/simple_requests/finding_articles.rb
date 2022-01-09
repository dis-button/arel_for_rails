# frozen_string_literal: true

class SimpleRequests::FindingArticles
  class << self
    def call
      Application::Article.
        where(Application::Article.arel_table[:subject].matches('%arel%')).
        where(Application::Article.arel_table[:created_at].lteq(DateTime.current - 1.day))
    end
  end
end
