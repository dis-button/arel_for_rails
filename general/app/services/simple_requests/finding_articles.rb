# frozen_string_literal: true

class SimpleRequests::FindingArticles
  class << self
    def call(matching_text, created_before)
      Application::Article.
        where(Application::Article.arel_table[:subject].matches("%#{matching_text}%")).
        where(Application::Article.arel_table[:created_at].lteq(created_before))
    end
  end
end
