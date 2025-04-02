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

ActiveRecord::Schema[7.2].define(version: 2025_04_01_171403) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "max_weights", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_max_weights_on_name"
  end

  create_table "training_max_weights", force: :cascade do |t|
    t.decimal "record", precision: 7, scale: 2
    t.bigint "training_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "max_weight_id", null: false
    t.index ["max_weight_id"], name: "index_training_max_weights_on_max_weight_id"
    t.index ["training_id"], name: "index_training_max_weights_on_training_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "datetime"
    t.string "part"
    t.text "content"
    t.text "memo"
    t.decimal "body_weight", precision: 5, scale: 2
    t.decimal "body_fat", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_trainings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "training_max_weights", "max_weights"
  add_foreign_key "training_max_weights", "trainings"
  add_foreign_key "trainings", "users"
end
