class FunctionsAndAttributes::OrderingArticles
  class << self
    def call
      Article.
        select(
          Arel.star,
          Arel::Nodes::NamedFunction.new('length', [Article.arel_table[:body]]).as('body_length')
        ).
        order(Arel::Nodes::NamedFunction.new('length', [Article.arel_table[:body]]).desc)
    end
  end
end
