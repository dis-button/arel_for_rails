class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles, comment: 'Articles' do |t|
      t.string :subject, null: false, index: true, comment: 'subject of the article'
      t.text :body, comment: 'body of the article'
      t.references :author,
        foreign_key: { to_table: :users },
        null: false,
        index: true,
        comment: 'user who created the article'

      t.timestamps
    end
  end
end
