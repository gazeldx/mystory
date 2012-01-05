# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120104101311) do

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "recommend",   :default => false
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs", ["category_id"], :name => "index_blogs_on_category_id"
  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "hobbies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "idols", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memoirs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memoirs", ["user_id"], :name => "index_memoirs_on_user_id"

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rblogs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rblogs", ["blog_id"], :name => "index_rblogs_on_blog_id"
  add_index "rblogs", ["user_id"], :name => "index_rblogs_on_user_id"

  create_table "rhobbies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "hobby_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rhobbies", ["hobby_id"], :name => "index_rhobbies_on_hobby_id"
  add_index "rhobbies", ["user_id"], :name => "index_rhobbies_on_user_id"

  create_table "ridols", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idol_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ridols", ["idol_id"], :name => "index_ridols_on_idol_id"
  add_index "ridols", ["user_id"], :name => "index_ridols_on_user_id"

  create_table "rnotes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rnotes", ["note_id"], :name => "index_rnotes_on_note_id"
  add_index "rnotes", ["user_id"], :name => "index_rnotes_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "passwd"
    t.string   "email"
    t.string   "domain"
    t.string   "memo"
    t.string   "maxim"
    t.string   "avatar"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
