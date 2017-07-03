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

ActiveRecord::Schema.define(version: 20170703033957) do

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
    t.string   "job"
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

  create_table "confirmations", force: :cascade do |t|
    t.integer  "trader_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payoffs", force: :cascade do |t|
    t.integer  "trader_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "payoffs", ["trader_id"], name: "index_payoffs_on_trader_id"

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
    t.string   "japan_airport"
    t.string   "flight_name"
    t.string   "china_airport"
    t.time     "departure_time"
    t.time     "arrival_time"
    t.string   "in_charge_person"
    t.string   "in_charge_phone"
    t.string   "payment",                     default: "unpaid"
    t.string   "confirmation",                default: "unconfirmed"
    t.boolean  "delete_request",              default: false
    t.string   "ticket_no",                   default: ""
    t.integer  "total_man",                   default: 0
    t.integer  "total_woman",                 default: 0
    t.string   "system_code"
    t.string   "pdf"
    t.string   "japan_company",               default: "jcic"
    t.boolean  "has_full_schedule",           default: false
    t.string   "stay",                        default: ""
    t.string   "visit",                       default: ""
    t.string   "extra",                       default: ""
  end

  add_index "projects", ["trader_id", "created_at"], name: "index_projects_on_trader_id_and_created_at"
  add_index "projects", ["trader_id"], name: "index_projects_on_trader_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "master_id"
    t.integer  "slave_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "relationships", ["master_id", "slave_id"], name: "index_relationships_on_master_id_and_slave_id", unique: true
  add_index "relationships", ["master_id"], name: "index_relationships_on_master_id"
  add_index "relationships", ["slave_id"], name: "index_relationships_on_slave_id"

  create_table "schedules", force: :cascade do |t|
    t.integer  "project_id"
    t.date     "date"
    t.text     "plan"
    t.text     "hotel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schedules", ["project_id"], name: "index_schedules_on_project_id"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

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
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "indivisual_price",         default: 500
    t.integer  "group_price_indivisual",   default: 0
    t.integer  "group_price_1_10",         default: 0
    t.integer  "group_price_11_20",        default: 3000
    t.integer  "group_price_21_30",        default: 6000
    t.integer  "group_price_31_40",        default: 9000
    t.integer  "year_3_price",             default: 1000
    t.integer  "year_5_price",             default: 1000
    t.integer  "other_price",              default: 5000
    t.boolean  "activation",               default: true
    t.string   "validation_mode",          default: "easy"
    t.string   "group_japan_company",      default: "random"
    t.string   "individual_japan_company", default: "random"
    t.string   "guarantee_mode",           default: "normal"
    t.string   "work_mode",                default: "auto"
    t.string   "invoice_company",          default: "jcic"
    t.string   "authority",                default: "self"
    t.integer  "editable_min",             default: 5
    t.string   "invoice_sign_company",     default: "jcic"
    t.string   "auto_schedule",            default: "inactive"
    t.string   "bank_type",                default: "japan"
    t.float    "china_japan_rate",         default: 20.0
    t.string   "money_type",               default: "japan"
  end

  add_index "traders", ["account"], name: "index_traders_on_account", unique: true

end
