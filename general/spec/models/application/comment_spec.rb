# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Comment, type: :model do
  describe 'associations' do
    it 'belong to commenter' do
      is_expected.to(
        belong_to(:commenter).
        class_name('Application::User')
      )
    end

    it 'belong to commenter' do
      is_expected.to(
        belong_to(:article).
        class_name('Application::Article')
      )
    end

    it 'belong to parent' do
      is_expected.to(
        belong_to(:parent).
        class_name('Application::Comment').
        optional
      )
    end

    it 'has_many children comments' do
      is_expected.to(
        have_many(:children).
        dependent(:destroy).
        with_foreign_key(:parent_id).
        class_name('Application::Comment')
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end
end

# == Schema Information
#
# Table name: comments
#
#  id                                         :bigint           not null, primary key
#  content(content of the comment)            :string           not null
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  article_id(commented article)              :bigint           not null
#  commenter_id(user who created the comment) :bigint           not null
#  parent_id(comments parent)                 :bigint
#
# Indexes
#
#  index_comments_on_article_id    (article_id)
#  index_comments_on_commenter_id  (commenter_id)
#  index_comments_on_parent_id     (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (commenter_id => users.id)
#  fk_rails_...  (parent_id => comments.id)
#
