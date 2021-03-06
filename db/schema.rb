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

ActiveRecord::Schema.define(version: 20150503062327) do

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "record_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.boolean  "accept",     default: false,  null: false
    t.string   "state",      default: "wait", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", force: true do |t|
    t.integer  "user_id"
    t.float    "value"
    t.text     "remark"
    t.string   "ymdhms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "klass",      default: -1,    null: false
    t.string   "browser"
    t.string   "ip"
    t.boolean  "deleted",    default: false
    t.text     "items"
  end

  create_table "records_tags", force: true do |t|
    t.integer  "record_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.integer  "user_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "klass",      default: -1,    null: false
    t.string   "ip"
    t.string   "browser"
    t.boolean  "deleted",    default: false
  end

  create_table "user_reports", force: true do |t|
    t.integer  "user_id"
    t.float    "maximum_per_one"
    t.float    "maximum_per_day"
    t.float    "summary_by_day"
    t.float    "summary_by_week"
    t.float    "summary_by_month"
    t.float    "summary_by_year"
    t.float    "summary_by_all"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "gender"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "records_count",          default: 0
    t.integer  "tags_count",             default: 0
    t.string   "password_salt"
    t.string   "remember_token"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
