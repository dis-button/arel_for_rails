# frozen_string_literal: true

class Application::User < ApplicationRecord
  has_many :comments,
           dependent: :destroy,
           class_name: 'Application::Comment',
           foreign_key: :commenter_id,
           inverse_of: :commenter

  has_many :articles,
           dependent: :destroy,
           class_name: 'Application::Article',
           foreign_key: :author_id,
           inverse_of: :author

  validates :username, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: users
#
#  id                                               :bigint           not null, primary key
#  username(username - user identification by name) :string           not null
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
