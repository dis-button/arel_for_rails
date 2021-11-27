class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, comment: 'Application users' do |t|
      t.string :username,
        index: { unique: true },
        null: false,
        comment: 'username - user identification by name'

      t.timestamps
    end
  end
end
