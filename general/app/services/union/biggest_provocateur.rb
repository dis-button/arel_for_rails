class Union::BiggestProvocateur
  class << self
    def call
      users_comments = Comment.
        joins(:commenter).
        where(User.arel_table[:username].eq('martins.kruze')).
        arel

      users_articles_comments = Comment.
        joins(article: :author).
        where(User.arel_table[:username].eq('martins.kruze')).
        arel

      unionized_results = Arel::Nodes::As.new(
        Arel::Nodes::Union.new(users_comments, users_articles_comments),
        Comment.arel_table
       )

       Comment.from(unionized_results)
    end
  end
end
