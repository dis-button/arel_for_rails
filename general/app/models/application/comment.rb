class Application::Comment < ApplicationRecord
  belongs_to :commenter,
    class_name: 'Application::User'

  belongs_to :article,
    class_name: 'Application::Article'

  belongs_to :parent,
    class_name: 'Application::Comment',
    optional: true

  has_many :children,
    class_name: 'Application::Comment',
    foreign_key: :parent_id,
    dependent: :destroy

  validates :content, presence: true
  validates :commenter, presence: true
  validates :article, presence: true
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
