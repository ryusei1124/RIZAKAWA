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

ActiveRecord::Schema.define(version: 20200215121131) do

  create_table "notices", force: :cascade do |t|
    t.string "notice_title"
    t.text "notice_content"
    t.boolean "all_destinate"
    t.boolean "part_of_destinate"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "guardian"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "student"
    t.boolean "real", default: false
    t.boolean "zoom", default: false
    t.string "sex"
    t.string "school"
    t.integer "school_year"
    t.boolean "admin", default: false
    t.datetime "attendance_time"
    t.datetime "leave_time"
    t.string "fix_day"
    t.datetime "fix_time"
    t.date "birthday"
    t.date "withdrawal"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
