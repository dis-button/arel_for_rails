# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments, comment: 'Users comments to article' do |t|
      t.string :content, null: false, comment: 'content of the comment'
      t.references :article,
                   null: false,
                   index: true,
                   comment: 'commented article'
      t.references :commenter,
                   foreign_key: { to_table: :users },
                   null: false,
                   index: true,
                   comment: 'user who created the comment'
      t.references :parent,
                   foreign_key: { to_table: :comments },
                   index: true,
                   comment: 'comments parent'

      t.timestamps
    end
  end
end
