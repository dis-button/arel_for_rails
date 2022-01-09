class FunctionsAndAttributes::OrderingArticles
  class << self
    def call
      Application::Article.
        select(
          Arel.star,
          Arel::Nodes::NamedFunction.new('length', [Application::Article.arel_table[:body]]).as('body_length')
        ).
        order(Arel::Nodes::NamedFunction.new('length', [Application::Article.arel_table[:body]]).desc)
    end
  end
end
