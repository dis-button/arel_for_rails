class Application::Article < ApplicationRecord
  belongs_to :author, class_name: 'Application::User'
  has_many :comments, dependent: :destroy, class_name: 'Application::Comment'
end
