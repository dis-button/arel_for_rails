# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimpleRequests::FindingArticles do
  describe '.call' do
    subject { described_class.call(matching_text, created_before).pluck(:id) }

    let!(:old_arel_article) do
      create(:article, subject: 'nice arel information', created_at: DateTime.current - 5.days)
    end
    let!(:old_magic_article) do
      create(:article, subject: 'about secrets', created_at: DateTime.current - 5.days)
    end
    let!(:new_arel_article) do
      create(:article, subject: 'other arel stats', created_at: DateTime.current)
    end

    context 'when searching by all arel articles' do
      let(:matching_text) { 'arel' }
      let(:created_before) { DateTime.current }

      it { is_expected.to match_array([old_arel_article.id, new_arel_article.id]) }
    end

    context 'when searching by older arel articles' do
      let(:matching_text) { 'arel' }
      let(:created_before) { DateTime.current - 1.day }

      it { is_expected.to match_array([old_arel_article.id]) }
    end
  end
end
