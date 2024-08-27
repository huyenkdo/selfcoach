# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_26_091854) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "programs", force: :cascade do |t|
    t.float "objective_km"
    t.float "objective_time"
    t.date "race_date"
    t.integer "free_days", array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_programs_on_user_id"
  end

  create_table "running_sessions", force: :cascade do |t|
    t.bigint "run_id", null: false
    t.date "date"
    t.bigint "program_id", null: false
    t.string "status", default: "uncompleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_running_sessions_on_program_id"
    t.index ["run_id"], name: "index_running_sessions_on_run_id"
  end

  create_table "runs", force: :cascade do |t|
    t.float "run_interval_km"
    t.float "run_interval_time"
    t.float "run_interval_pace"
    t.float "rest_interval_km"
    t.float "rest_interval_time"
    t.float "rest_interval_pace"
    t.string "hr_zone"
    t.integer "difficulty"
    t.string "kind"
    t.integer "run_interval_nbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.integer "weight"
    t.integer "age"
    t.integer "vma"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "strava_access_token"
    t.string "strava_refresh_token"
    t.datetime "strava_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "programs", "users"
  add_foreign_key "running_sessions", "programs"
  add_foreign_key "running_sessions", "runs"
end
