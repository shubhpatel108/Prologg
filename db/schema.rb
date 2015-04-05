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

ActiveRecord::Schema.define(version: 20150404093733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blog_links", force: true do |t|
    t.string "user_id", null: false
    t.string "url",     null: false
  end

  create_table "codeforces_profiles", force: true do |t|
    t.integer  "user_id",                    null: false
    t.string   "handle",       default: "0", null: false
    t.integer  "contribution", default: 0,   null: false
    t.string   "rank",         default: "",  null: false
    t.string   "max_rank",     default: "",  null: false
    t.integer  "rating",       default: 0,   null: false
    t.integer  "max_rating",   default: 0,   null: false
    t.datetime "last_online",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "metadata",     default: {}
  end

  create_table "facebook_links", force: true do |t|
    t.string "user_id", null: false
    t.string "url",     null: false
  end

  create_table "github_profiles", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "username",   null: false
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "gplus_links", force: true do |t|
    t.string "user_id", null: false
    t.string "url",     null: false
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["name"], name: "index_languages_on_name", using: :btree

  create_table "languages_users", id: false, force: true do |t|
    t.integer "language_id"
    t.integer "user_id"
  end

  add_index "languages_users", ["language_id"], name: "index_languages_users_on_language_id", using: :btree
  add_index "languages_users", ["user_id"], name: "index_languages_users_on_user_id", using: :btree

  create_table "linkedin_profiles", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "uid",        null: false
    t.string   "token",      null: false
    t.string   "secret",     null: false
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

  create_table "mail_notifications", force: true do |t|
    t.integer  "sender_id",                   null: false
    t.integer  "receiver_id",                 null: false
    t.boolean  "status",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quora_links", force: true do |t|
    t.string "user_id", null: false
    t.string "url",     null: false
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "topcoder_profiles", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "handle",     null: false
    t.json     "data",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_links", force: true do |t|
    t.string "user_id", null: false
    t.string "url",     null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "username",               default: "",   null: false
    t.string   "full_name",              default: "",   null: false
    t.string   "short_bio",              default: ""
    t.boolean  "gender",                 default: true
    t.boolean  "availability",           default: true
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "view_count",             default: 0
    t.integer  "location_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["full_name"], name: "index_users_on_full_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["short_bio"], name: "index_users_on_short_bio", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "website_links", force: true do |t|
    t.string "user_id", null: false
    t.string "url",     null: false
  end

end
