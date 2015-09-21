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

ActiveRecord::Schema.define(version: 20150921000024) do

  create_table "clients", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name_chinese"
    t.string   "name_english"
    t.string   "gender"
    t.string   "hometown"
    t.date     "birthday"
    t.string   "passport_no"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "clients", ["project_id"], name: "index_clients_on_project_id"

  create_table "company_codes", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "locate"
    t.string   "status"
    t.string   "memo"
    t.string   "address"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "search_text"
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "trader_id"
    t.string   "china_company_name"
    t.string   "china_company_code"
    t.string   "visa_type"
    t.integer  "total_people"
    t.string   "representative_name_english"
    t.string   "representative_name_chinese"
    t.date     "date_arrival"
    t.date     "date_leaving"
    t.string   "status",                      default: "uncommitted"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "stay_term"
  end

  add_index "projects", ["trader_id", "china_company_code", "visa_type", "total_people", "representative_name_english", "date_arrival", "date_leaving"], name: "unique_project_condition", unique: true
  add_index "projects", ["trader_id", "created_at"], name: "index_projects_on_trader_id_and_created_at"
  add_index "projects", ["trader_id"], name: "index_projects_on_trader_id"

  create_table "schedules", force: :cascade do |t|
    t.integer  "project_id"
    t.date     "date"
    t.text     "plan"
    t.text     "hotel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schedules", ["project_id"], name: "index_schedules_on_project_id"

  create_table "traders", force: :cascade do |t|
    t.string   "account"
    t.string   "password_backup"
    t.string   "password_digest"
    t.string   "company_name"
    t.string   "person_name"
    t.string   "telephone"
    t.string   "fax"
    t.string   "qq"
    t.string   "bank"
    t.string   "address"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "traders", ["account"], name: "index_traders_on_account", unique: true

end
