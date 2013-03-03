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

ActiveRecord::Schema.define(:version => 20130227005407) do

  create_table "albums", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "albums", ["user_id"], :name => "index_albums_on_user_id"

  create_table "assortments", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assortments", ["user_id"], :name => "index_assortments_on_user_id"

  create_table "blogcomments", :force => true do |t|
    t.text     "body"
    t.integer  "blog_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likecount",  :default => 0
    t.text     "likeusers"
  end

  add_index "blogcomments", ["blog_id"], :name => "index_blogcomments_on_blog_id"
  add_index "blogcomments", ["user_id"], :name => "index_blogcomments_on_user_id"

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views_count",     :default => 0
    t.integer  "comments_count",  :default => 0
    t.integer  "recommend_count", :default => 0
    t.datetime "replied_at"
    t.boolean  "is_draft",        :default => false
    t.integer  "columns_count",   :default => 0
  end

  add_index "blogs", ["category_id"], :name => "index_blogs_on_category_id"
  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

  create_table "blogs_columns", :id => false, :force => true do |t|
    t.integer  "column_id"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs_columns", ["blog_id"], :name => "index_blogs_columns_on_blog_id"
  add_index "blogs_columns", ["column_id"], :name => "index_blogs_columns_on_column_id"

  create_table "blogs_gcolumns", :id => false, :force => true do |t|
    t.integer  "gcolumn_id"
    t.integer  "blog_id"
    t.datetime "created_at"
  end

  add_index "blogs_gcolumns", ["blog_id"], :name => "index_blogs_gcolumns_on_blog_id"
  add_index "blogs_gcolumns", ["gcolumn_id"], :name => "index_blogs_gcolumns_on_gcolumn_id"

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books_books", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "body"
    t.string   "writer"
    t.string   "translator"
    t.float    "price"
    t.string   "avatar"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chats", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "chats", ["group_id"], :name => "index_chats_on_group_id"
  add_index "chats", ["user_id"], :name => "index_chats_on_user_id"

  create_table "columns", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "columns_notes", :id => false, :force => true do |t|
    t.integer  "column_id"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "columns_notes", ["column_id"], :name => "index_columns_notes_on_column_id"
  add_index "columns_notes", ["note_id"], :name => "index_columns_notes_on_note_id"

  create_table "customizes", :force => true do |t|
    t.string   "bgimage"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customizes", ["user_id"], :name => "index_customizes_on_user_id"

  create_table "enjoys", :force => true do |t|
    t.string   "name"
    t.integer  "stype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fboards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fboards", ["board_id"], :name => "index_fboards_on_board_id"
  add_index "fboards", ["user_id"], :name => "index_fboards_on_user_id"

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

  create_table "gads", :force => true do |t|
    t.string   "avatar"
    t.integer  "stype"
    t.string   "url"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "gads", ["group_id"], :name => "index_gads_on_group_id"

  create_table "gcolumns", :force => true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at"
  end

  add_index "gcolumns", ["group_id"], :name => "index_gcolumns_on_group_id"

  create_table "gcolumns_notes", :id => false, :force => true do |t|
    t.integer  "gcolumn_id"
    t.integer  "note_id"
    t.datetime "created_at"
  end

  add_index "gcolumns_notes", ["gcolumn_id"], :name => "index_gcolumns_notes_on_gcolumn_id"
  add_index "gcolumns_notes", ["note_id"], :name => "index_gcolumns_notes_on_note_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.string   "memo"
    t.string   "maxim"
    t.string   "avatar"
    t.integer  "member_count", :default => 0
    t.integer  "stype"
    t.integer  "board_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.boolean  "is_admin",   :default => false
  end

  add_index "groups_users", ["group_id"], :name => "index_groups_users_on_group_id"
  add_index "groups_users", ["user_id"], :name => "index_groups_users_on_user_id"

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

  create_table "letters", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "letters", ["recipient_id"], :name => "index_letters_on_recipient_id"
  add_index "letters", ["user_id"], :name => "index_letters_on_user_id"

  create_table "memoircomments", :force => true do |t|
    t.text     "body"
    t.integer  "memoir_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likecount",  :default => 0
    t.text     "likeusers"
  end

  add_index "memoircomments", ["memoir_id"], :name => "index_memoircomments_on_memoir_id"
  add_index "memoircomments", ["user_id"], :name => "index_memoircomments_on_user_id"

  create_table "memoirs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views_count",     :default => 0
    t.integer  "comments_count",  :default => 0
    t.integer  "recommend_count", :default => 0
  end

  add_index "memoirs", ["user_id"], :name => "index_memoirs_on_user_id"

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus_roles", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "stype",      :default => 0
    t.text     "body"
    t.string   "parameters"
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "notecates", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notecates", ["user_id"], :name => "index_notecates_on_user_id"

  create_table "notecomments", :force => true do |t|
    t.text     "body"
    t.integer  "note_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likecount",  :default => 0
    t.text     "likeusers"
  end

  add_index "notecomments", ["note_id"], :name => "index_notecomments_on_note_id"
  add_index "notecomments", ["user_id"], :name => "index_notecomments_on_user_id"

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notecate_id"
    t.integer  "views_count",     :default => 0
    t.integer  "comments_count",  :default => 0
    t.integer  "recommend_count", :default => 0
    t.boolean  "is_draft",        :default => false
    t.datetime "replied_at"
    t.integer  "columns_count",   :default => 0
  end

  add_index "notes", ["notecate_id"], :name => "index_notes_on_notecate_id"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"

  create_table "notetags", :force => true do |t|
    t.string  "name"
    t.integer "note_id"
  end

  add_index "notetags", ["name"], :name => "index_notetags_on_name"
  add_index "notetags", ["note_id"], :name => "index_notetags_on_note_id"

  create_table "photocomments", :force => true do |t|
    t.text     "body"
    t.integer  "photo_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likecount",  :default => 0
    t.text     "likeusers"
  end

  add_index "photocomments", ["photo_id"], :name => "index_photocomments_on_photo_id"
  add_index "photocomments", ["user_id"], :name => "index_photocomments_on_user_id"

  create_table "photos", :force => true do |t|
    t.string   "description"
    t.string   "avatar"
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views_count",     :default => 0
    t.integer  "comments_count",  :default => 0
    t.integer  "recommend_count", :default => 0
  end

  add_index "photos", ["album_id"], :name => "index_photos_on_album_id"

  create_table "postcomments", :force => true do |t|
    t.text     "body"
    t.integer  "likecount",  :default => 0
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "likeusers"
  end

  add_index "postcomments", ["post_id"], :name => "index_postcomments_on_post_id"
  add_index "postcomments", ["user_id"], :name => "index_postcomments_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "board_id"
    t.integer  "user_id"
    t.datetime "replied_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rblogs", :force => true do |t|
    t.string   "body"
    t.integer  "user_id"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rblogs", ["blog_id"], :name => "index_rblogs_on_blog_id"
  add_index "rblogs", ["user_id"], :name => "index_rblogs_on_user_id"

  create_table "renjoys", :force => true do |t|
    t.integer  "user_id"
    t.integer  "enjoy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "renjoys", ["enjoy_id"], :name => "index_renjoys_on_enjoy_id"
  add_index "renjoys", ["user_id"], :name => "index_renjoys_on_user_id"

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

  create_table "rmemoirs", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "memoir_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rmemoirs", ["memoir_id"], :name => "index_rmemoirs_on_memoir_id"
  add_index "rmemoirs", ["user_id"], :name => "index_rmemoirs_on_user_id"

  create_table "rnotes", :force => true do |t|
    t.string   "body"
    t.integer  "user_id"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rnotes", ["note_id"], :name => "index_rnotes_on_note_id"
  add_index "rnotes", ["user_id"], :name => "index_rnotes_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "rphotos", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rphotos", ["photo_id"], :name => "index_rphotos_on_photo_id"
  add_index "rphotos", ["user_id"], :name => "index_rphotos_on_user_id"

  create_table "schoolnames", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "group_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "blog_id"
  end

  add_index "tags", ["blog_id"], :name => "index_tags_on_blog_id"
  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tracemaps", :force => true do |t|
    t.string   "siteid"
    t.string   "sitename"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracemaps", ["blog_id"], :name => "index_tracemaps_on_blog_id"
  add_index "tracemaps", ["siteid"], :name => "index_tracemaps_on_siteid"

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
    t.integer  "birthday"
    t.string   "jobs"
    t.string   "company"
    t.string   "school"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "snslinks"
    t.text     "signature"
    t.string   "weiboid"
    t.string   "atoken"
    t.string   "asecret"
    t.string   "openid"
    t.string   "token"
    t.integer  "source",                 :default => 0
    t.integer  "followers_num",          :default => 0
    t.integer  "following_num",          :default => 0
    t.integer  "blogs_count",            :default => 0
    t.integer  "notes_count",            :default => 0
    t.integer  "photos_count",           :default => 0
    t.datetime "view_comments_at"
    t.datetime "view_commented_at"
    t.integer  "unread_comments_count",  :default => 0
    t.integer  "unread_commented_count", :default => 0
    t.datetime "view_letters_at"
    t.integer  "unread_letters_count",   :default => 0
    t.integer  "comments_count",         :default => 0
    t.string   "contact"
    t.integer  "clicks_count",           :default => 0
    t.datetime "view_messages_at",       :default => '2012-10-28 09:43:16'
    t.integer  "unread_messages_count",  :default => 0
  end

end
