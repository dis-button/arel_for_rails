# frozen_string_literal: true

class Application::Article < ApplicationRecord
  belongs_to :author, class_name: 'Application::User'
  has_many :comments, dependent: :destroy, class_name: 'Application::Comment'

  validates :subject, presence: true
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
