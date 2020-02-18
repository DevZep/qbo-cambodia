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

ActiveRecord::Schema.define(version: 20200218115653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "qbo_credentials", force: :cascade do |t|
    t.string   "access_token"
    t.string   "access_secret"
    t.string   "company_id"
    t.datetime "token_expires_at"
    t.datetime "reconnect_token_at"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "company_name"
    t.text     "oauth2_access_token"
    t.datetime "oauth2_access_token_expires_at"
    t.text     "oauth2_refresh_token"
    t.datetime "oauth2_refresh_token_expires_at"
    t.index ["user_id"], name: "index_qbo_credentials_on_user_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "translation_customers", force: :cascade do |t|
    t.integer  "qbo_customer_id"
    t.string   "language_code",   default: "km"
    t.string   "name"
    t.string   "billing_address"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "company_id"
    t.index ["company_id", "qbo_customer_id", "language_code"], name: "index_company_id_customers_id_and_code", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "last_login_company"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
