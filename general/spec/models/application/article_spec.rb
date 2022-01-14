# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Article, type: :model do
  describe 'associations' do
    it 'has_many comments' do
      is_expected.to(
        have_many(:comments).
        dependent(:destroy).
        class_name('Application::Comment')
      )
    end

    it 'belong to author' do
      is_expected.to(
        belong_to(:author).
        class_name('Application::User')
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:subject) }
  end
end

# == Schema Information
#
# Table name: articles
#
#  id                                      :bigint           not null, primary key
#  body(body of the article)               :text
#  subject(subject of the article)         :string           not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  author_id(user who created the article) :bigint           not null
#
# Indexes
#
#  index_articles_on_author_id  (author_id)
#  index_articles_on_subject    (subject)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
