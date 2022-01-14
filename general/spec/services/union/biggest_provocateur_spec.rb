# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Union::BiggestProvocateur do
  describe '.call' do
    describe 'collecting of a collection' do
      subject { described_class.call(username).pluck(:id) }

      before do
        # just some other data - comment for another article by another user
        create(:comment)
      end

      let(:username) { 'Johnny Bravo' }
      let(:user) { create(:user, username: username) }
      let!(:article) { create(:article, author: user) }
      let!(:users_comment_for_users_article) { create(:comment, commenter: user, article: article) }
      let!(:users_comment_for_another_article) { create(:comment, commenter: user) }
      let!(:comment_for_users_article) { create(:comment, article: article) }
      let(:expected_result) do
        [
          users_comment_for_users_article.id,
          users_comment_for_another_article.id,
          comment_for_users_article.id
        ]
      end

      it { is_expected.to match_array(expected_result) }
    end
  end

  describe 'engaging with result' do
    subject { described_class.call(username).pluck(:content) }

    let(:username) { 'Cordell Walker' }
    let(:user) { create(:user, username: username) }

    before do
      create(:comment, commenter: user, content: 'accessible attribute')
    end

    it { is_expected.to match_array(['accessible attribute']) }
  end
end
