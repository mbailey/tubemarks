# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080620130031) do

  create_table "marks", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.integer  "category"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "forgotten_password_link"
  end

  add_index "users", ["forgotten_password_link"], :name => "index_users_on_forgotten_password_link"
  add_index "users", ["email"], :name => "index_users_on_email"

  create_table "videos", :force => true do |t|
    t.string   "v"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "thumbnail_url"
    t.integer  "length_seconds"
    t.integer  "user_id"
    t.integer  "adder"
    t.boolean  "private",        :default => false
  end

  create_table "views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
