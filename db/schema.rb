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

ActiveRecord::Schema.define(version: 2020_05_04_025656) do

  create_table "answers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "question_id", null: false
    t.text "answer_content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessoncomments", force: :cascade do |t|
    t.integer "lesson_id", null: false
    t.integer "user_id", null: false
    t.integer "reservation_id"
    t.integer "student_id"
    t.string "content", null: false
    t.integer "noted", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.date "meeting_on", null: false
    t.time "started_at", null: false
    t.time "finished_at", null: false
    t.text "note"
    t.string "target"
    t.integer "seats_zoom"
    t.integer "seats_real"
    t.boolean "off_day", default: false, null: false
    t.boolean "rescheduled", default: false, null: false
    t.boolean "regular", default: true, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "examinee", default: false
    t.boolean "hold", default: false
    t.boolean "cancel", default: false
    t.index ["user_id"], name: "index_lessons_on_user_id"
  end

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

  create_table "questions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "question_title", null: false
    t.text "question_content", null: false
    t.integer "student_id"
    t.integer "destination", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.boolean "attendance", default: true, null: false
    t.boolean "zoom", default: false, null: false
    t.string "note"
    t.integer "user_id"
    t.integer "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
    t.boolean "waiting", default: false
    t.time "attendance_time"
    t.time "leave_time"
    t.boolean "absence", default: false
    t.boolean "transfer", default: false
    t.time "fix_time"
    t.index ["lesson_id"], name: "index_reservations_on_lesson_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "student_name"
    t.boolean "real", default: false
    t.boolean "zoom", default: false
    t.string "school"
    t.integer "school_year"
    t.time "attendance_time"
    t.datetime "leave_time"
    t.datetime "birthday"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fix_day"
    t.time "fix_time"
    t.string "studentkana"
    t.date "withdrawal"
    t.string "fix_day2"
    t.time "fix_time2"
    t.string "fix_day3"
    t.time "fix_time3"
    t.boolean "examinee", default: false
    t.integer "cancelnumber"
    t.text "note"
  end

  create_table "users", force: :cascade do |t|
    t.string "guardian"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "student"
    t.boolean "zoom", default: false
    t.boolean "admin", default: false
    t.date "withdrawal"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "guardiankana"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
