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

ActiveRecord::Schema.define(:version => 20120610130210) do

  create_table "spud_admin_permissions", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "access"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "scope"
  end

  create_table "spud_post_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "parent_id",  :default => 0
    t.string   "url_name"
  end

  add_index "spud_post_categories", ["parent_id"], :name => "index_spud_post_categories_on_parent_id"
  add_index "spud_post_categories", ["url_name"], :name => "index_spud_post_categories_on_url_name"

  create_table "spud_post_categories_posts", :id => false, :force => true do |t|
    t.integer "spud_post_id"
    t.integer "spud_post_category_id"
  end

  add_index "spud_post_categories_posts", ["spud_post_category_id"], :name => "index_spud_post_categories_posts_on_spud_post_category_id"

  create_table "spud_post_comments", :force => true do |t|
    t.integer  "spud_post_id"
    t.string   "author"
    t.text     "content"
    t.boolean  "approved",     :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "spud_post_comments", ["approved"], :name => "index_spud_post_comments_on_approved"
  add_index "spud_post_comments", ["spud_post_id"], :name => "index_spud_post_comments_on_spud_post_id"

  create_table "spud_posts", :force => true do |t|
    t.integer  "spud_user_id"
    t.string   "title"
    t.text     "content"
    t.boolean  "comments_enabled", :default => false
    t.boolean  "visible",          :default => true
    t.datetime "published_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "url_name"
    t.boolean  "is_news",          :default => false
    t.string   "meta_keywords"
    t.text     "meta_description"
    t.integer  "comments_count",   :default => 0
  end

  add_index "spud_posts", ["is_news"], :name => "index_spud_posts_on_is_news"
  add_index "spud_posts", ["spud_user_id"], :name => "index_spud_posts_on_spud_user_id"
  add_index "spud_posts", ["url_name"], :name => "index_spud_posts_on_url_name"
  add_index "spud_posts", ["visible"], :name => "index_spud_posts_on_visible"

  create_table "spud_user_settings", :force => true do |t|
    t.integer  "spud_user_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "spud_users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "super_admin"
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "time_zone"
  end

  add_index "spud_users", ["email"], :name => "index_spud_users_on_email"
  add_index "spud_users", ["login"], :name => "index_spud_users_on_login"

end
