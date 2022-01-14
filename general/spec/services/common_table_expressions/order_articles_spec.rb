# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommonTableExpressions::OrderArticles do
  describe '.call' do
    describe 'collecting of a collection' do
      subject { described_class.call.pluck(:id) }

      before do
        create(:comment, article: large_comment_article, content: 'a' * 50)
        create(:comment, article: large_comment_article, content: 'a' * 5)
        create(:comment, article: small_comment_article, content: 'a' * 10)
        create(:comment, article: small_comment_article, content: 'a' * 45)
      end
      let(:large_comment_article) { create(:article) }
      let(:small_comment_article) { create(:article) }

      it { is_expected.to eq([large_comment_article.id, small_comment_article.id]) }
    end

    describe 'collecting extra attributes' do
      subject { described_class.call.map { |a| [a.subject, a.comment_length].join(': ') } }

      before { create(:comment, article: article, content: 'a' * 50) }
      let(:article) { create(:article, subject: 'Nice one') }

      it { is_expected.to eq(['Nice one: 50']) }
    end
  end
end
