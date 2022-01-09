# frozen_string_literal: true

FactoryBot.define do
  factory :article, class: 'Application::Article' do
    author
    subject { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
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
