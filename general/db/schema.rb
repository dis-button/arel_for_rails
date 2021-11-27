# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_27_140456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", comment: "Articles", force: :cascade do |t|
    t.string "subject", null: false, comment: "subject of the article"
    t.text "body", comment: "body of the article"
    t.bigint "author_id", null: false, comment: "user who created the article"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["subject"], name: "index_articles_on_subject"
  end

  create_table "comments", comment: "Users comments to article", force: :cascade do |t|
    t.string "content", null: false, comment: "content of the comment"
    t.bigint "article_id", null: false, comment: "commented article"
    t.bigint "commenter_id", null: false, comment: "user who created the comment"
    t.bigint "parent_id", comment: "comments parent"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["commenter_id"], name: "index_comments_on_commenter_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
  end

  create_table "users", comment: "Application users", force: :cascade do |t|
    t.string "username", null: false, comment: "username - user identification by name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "articles", "users", column: "author_id"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "users", column: "commenter_id"
end
