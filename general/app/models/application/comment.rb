class Application::Comment < ApplicationRecord
  belongs_to :commenter, class_name: 'Application::User'
  belongs_to :article, class_name: 'Application::Article'
  belongs_to :parent, class_name: 'Application::Comment', optional: true
  has_many :children, class_name: 'Application::Comment', foreign_key: :parent_id, dependent: :destroy
end
