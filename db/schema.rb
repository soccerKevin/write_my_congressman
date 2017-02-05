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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170201051226) do

  create_table "addresses", force: :cascade do |t|
    t.integer "legislator_id"
    t.string  "line"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.integer "user_id"
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"

  create_table "authentication_providers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentication_providers", ["name"], name: "index_name_on_authentication_providers"

  create_table "legislators", force: :cascade do |t|
    t.string "bio_id"
    t.string "first_name"
    t.string "last_name"
    t.date   "birthday"
    t.string "gender"
    t.string "religion"
    t.string "position"
    t.string "party"
    t.date   "started"
    t.string "state"
    t.string "district"
    t.string "url"
    t.string "contact_form_url"
    t.string "twitter_name"
    t.string "facebook_name"
    t.string "facebook_id"
    t.string "youtube_id"
    t.string "twitter_id"
  end

  add_index "legislators", ["last_name"], name: "index_legislators_on_last_name"

  create_table "phones", force: :cascade do |t|
    t.integer "legislator_id"
    t.string  "number"
  end

  create_table "user_authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "authentication_provider_id"
    t.string   "uid"
    t.string   "token"
    t.datetime "token_expires_at"
    t.text     "params"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "user_authentications", ["authentication_provider_id"], name: "index_user_authentications_on_authentication_provider_id"
  add_index "user_authentications", ["user_id"], name: "index_user_authentications_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
