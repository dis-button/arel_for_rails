# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrStatements::ArticlesByTitleOrCreationTime do
  describe '.call' do
    subject { described_class.call(matching_text, created_before).pluck(:id) }

    before do
      create(:article, subject: 'about secrets', created_at: DateTime.current - 3.days)
    end

    let!(:old_arel_article) do
      create(:article, subject: 'nice arel information', created_at: DateTime.current - 5.days)
    end

    let!(:new_cat_article) do
      create(:article, subject: 'about cats', created_at: DateTime.current)
    end
    let(:matching_text) { 'cats' }
    let(:created_before) { DateTime.current - 4.days }

    it { is_expected.to match_array([old_arel_article.id, new_cat_article.id]) }
  end
end
