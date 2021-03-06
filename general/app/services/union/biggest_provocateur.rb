# frozen_string_literal: true

class Union::BiggestProvocateur
  class << self
    def call(username)
      users_comments = Application::Comment.
        joins(:commenter).
        where(Application::User.arel_table[:username].eq(username)).
        arel

      users_articles_comments = Application::Comment.
        joins(article: :author).
        where(Application::User.arel_table[:username].eq(username)).
        arel

      unionized_results = Arel::Nodes::As.new(
        Arel::Nodes::Union.new(users_comments, users_articles_comments),
        Application::Comment.arel_table
      )

      Application::Comment.from(unionized_results)
    end
  end
end
