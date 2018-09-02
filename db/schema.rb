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

ActiveRecord::Schema.define(version: 20180901145734) do

  create_table "letsencrypt_certificates", force: :cascade do |t|
    t.string   "domain"
    t.text     "certificate",         limit: 65535
    t.text     "intermediaries",      limit: 65535
    t.text     "key",                 limit: 65535
    t.datetime "expires_at"
    t.datetime "renew_after"
    t.string   "verification_path"
    t.string   "verification_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "letsencrypt_certificates", ["domain"], name: "index_letsencrypt_certificates_on_domain"
  add_index "letsencrypt_certificates", ["renew_after"], name: "index_letsencrypt_certificates_on_renew_after"

  create_table "posts", force: :cascade do |t|
    t.integer  "parent"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "last_reply"
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key"

end
