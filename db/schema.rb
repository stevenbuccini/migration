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

ActiveRecord::Schema.define(:version => 20130625051036) do

  create_table "friends", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "current"
    t.string   "hometown"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "user_id"
    t.float    "current_longitude"
    t.float    "current_latitude"
    t.float    "hometown_longitude"
    t.float    "hometown_latitude"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "location"
    t.string   "image"
    t.boolean  "been_checked"
  end

end
