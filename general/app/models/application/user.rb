class Application::User < ApplicationRecord
  has_many :comments, dependent: :destroy, class_name: 'Application::Comment'
  has_many :articles, dependent: :destroy, class_name: 'Application::Article'
end
