factory :user, class: "Application::User" do
  username { Faker::Internet.unique.username }
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
