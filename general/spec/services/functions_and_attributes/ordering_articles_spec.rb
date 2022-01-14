# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FunctionsAndAttributes::OrderingArticles do
  describe '.call' do
    describe 'article sorting' do
      subject { described_class.call.pluck(:id) }

      let!(:medium_article) { create(:article, body: 'a' * 50) }
      let!(:small_article) { create(:article, body: 'a' * 10) }
      let!(:large_article) { create(:article, body: 'a' * 100) }

      it { is_expected.to match_array([large_article.id, medium_article.id, small_article.id]) }
    end

    describe 'extra attributes' do
      subject { described_class.call.map(&:body_length) }

      before do
        create(:article, body: 'a' * 14)
        create(:article, body: 'a' * 195)
      end

      it { is_expected.to match_array([14, 195]) }
    end
  end
end
