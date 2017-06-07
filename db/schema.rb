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

ActiveRecord::Schema.define(version: 20170607220539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "emergency_contact_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "notification_users", force: :cascade do |t|
    t.bigint "notification_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_notification_users_on_notification_id"
    t.index ["user_id"], name: "index_notification_users_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "message"
    t.string "title"
    t.string "profile"
    t.text "android_payload"
    t.text "ios_payload"
    t.date "scheduled"
    t.integer "production", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "phone_number", limit: 9, null: false
    t.string "authentication_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "device_token"
    t.text "device_type"
    t.string "ddd", limit: 2, null: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "contacts", "users"
  add_foreign_key "notification_users", "notifications"
  add_foreign_key "notification_users", "users"
end
