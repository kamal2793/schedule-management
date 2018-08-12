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

ActiveRecord::Schema.define(version: 20180811113213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "doctor_id"
    t.bigint "patient_id"
    t.bigint "slot_id"
    t.date "appointment_date", null: false
    t.text "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["slot_id"], name: "index_appointments_on_slot_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "event_id"
    t.bigint "doctor_id"
    t.bigint "slot_id"
    t.boolean "is_available", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_availabilities_on_doctor_id"
    t.index ["event_id"], name: "index_availabilities_on_event_id"
    t.index ["slot_id"], name: "index_availabilities_on_slot_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_doctors_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "doctor_id"
    t.integer "day_of_week"
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.boolean "is_available", default: true, null: false
    t.boolean "is_recurring", default: true, null: false
    t.text "recurrence_type", null: false
    t.integer "recurrence_step", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_events_on_doctor_id"
    t.index ["start_date", "end_date"], name: "index_events_on_start_date_and_end_date"
    t.index ["start_time", "end_time"], name: "index_events_on_start_time_and_end_time"
  end

  create_table "patients", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "slots", force: :cascade do |t|
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_time", "end_time"], name: "index_slots_on_start_time_and_end_time", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "email", null: false
    t.string "contact_number"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
