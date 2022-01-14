# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommonTableExpressions::ArticleWithLongestCommentChain do
  describe 'collecting of a collection' do
    subject { described_class.call.pluck(:id) }

    let!(:article_without_comments) { create(:article) }

    let(:one_thread) { create(:article) }
    let!(:one_thread_1) { create(:comment, article: one_thread) }
    let!(:one_thread_2) { create(:comment, article: one_thread, parent: one_thread_1) }
    let!(:one_thread_3) { create(:comment, article: one_thread, parent: one_thread_2) }

    let(:muti_threads) { create(:article) }
    let!(:multi_thread_1) { create(:comment, article: muti_threads) }
    let!(:multi_thread_2) { create(:comment, article: muti_threads) }
    let!(:multi_thread_3) { create(:comment, article: muti_threads) }
    let!(:multi_thread_4) { create(:comment, article: muti_threads) }

    let(:complex_threads) { create(:article) }
    let!(:complex_thread_1) { create(:comment, article: complex_threads) }
    let!(:complex_thread_2a) { create(:comment, article: complex_threads) }
    let!(:complex_thread_2b) do
      create(:comment, parent: complex_thread_2a, article: complex_threads)
    end
    let!(:complex_thread_2c) do
      create(:comment, parent: complex_thread_2b, article: complex_threads)
    end

    it { is_expected.to eq([complex_threads.id, muti_threads.id, one_thread.id]) }
  end

  describe 'collecting extra attributes' do
    subject { described_class.call.map(&:article_score) }

    let(:article) { create(:article) }
    let!(:thread_a_comment) { create(:comment, article: article) }
    let!(:thread_b_comment) { create(:comment, article: article) }
    let!(:thread_c_comment_1) { create(:comment, article: article) }
    let!(:thread_c_comment_2) { create(:comment, article: article, parent: thread_c_comment_1) }
    let!(:thread_c_comment_3a) { create(:comment, article: article, parent: thread_c_comment_2) }
    let!(:thread_c_comment_3b) { create(:comment, article: article, parent: thread_c_comment_2) }
    let!(:thread_c_comment_4) { create(:comment, article: article, parent: thread_c_comment_3a) }

    it { is_expected.to eq([12]) }
  end
end
