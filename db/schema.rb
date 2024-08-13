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

ActiveRecord::Schema[7.1].define(version: 2024_08_13_192660) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aofs", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "client_first_name"
    t.string "client_last_name"
    t.string "address", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "employee_aofs", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "aof_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aof_id"], name: "index_employee_aofs_on_aof_id"
    t.index ["employee_id", "aof_id"], name: "index_employee_aofs_on_employee_id_and_aof_id", unique: true
    t.index ["employee_id"], name: "index_employee_aofs_on_employee_id"
  end

  create_table "employee_languages", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "language_id"], name: "index_employee_languages_on_employee_id_and_language_id", unique: true
    t.index ["employee_id"], name: "index_employee_languages_on_employee_id"
    t.index ["language_id"], name: "index_employee_languages_on_language_id"
  end

  create_table "employee_locations", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "location_id"], name: "index_employee_locations_on_employee_id_and_location_id", unique: true
    t.index ["employee_id"], name: "index_employee_locations_on_employee_id"
    t.index ["location_id"], name: "index_employee_locations_on_location_id"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "employee_first_name", null: false
    t.string "employee_last_name", null: false
    t.date "date_of_birth"
    t.text "short_description"
    t.text "long_description"
    t.boolean "is_admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patient_languages", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_patient_languages_on_language_id"
    t.index ["patient_id", "language_id"], name: "index_patient_profile_languages_uniqueness", unique: true
    t.index ["patient_id"], name: "index_patient_languages_on_patient_id"
  end

  create_table "patient_locations", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_patient_locations_on_location_id"
    t.index ["patient_id", "location_id"], name: "index_patient_profile_locations_uniqueness", unique: true
    t.index ["patient_id"], name: "index_patient_locations_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "patient_first_name", null: false
    t.string "patient_last_name", null: false
    t.date "date_of_birth", null: false
    t.integer "gender", null: false
    t.boolean "has_prescription", null: false
    t.integer "health_insurance", null: false
    t.text "diagnosis", null: false
    t.string "kita_name"
    t.boolean "has_i_status"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_patients_on_client_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "clients", "users"
  add_foreign_key "employee_aofs", "aofs"
  add_foreign_key "employee_aofs", "employees"
  add_foreign_key "employee_languages", "employees"
  add_foreign_key "employee_languages", "languages"
  add_foreign_key "employee_locations", "employees"
  add_foreign_key "employee_locations", "locations"
  add_foreign_key "employees", "users"
  add_foreign_key "patient_languages", "languages"
  add_foreign_key "patient_languages", "patients"
  add_foreign_key "patient_locations", "locations"
  add_foreign_key "patient_locations", "patients"
  add_foreign_key "patients", "clients"
end
