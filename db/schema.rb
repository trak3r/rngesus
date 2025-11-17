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

ActiveRecord::Schema[8.1].define(version: 2025_11_17_201142) do
  create_table "examples", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "value"
  end

  create_table "randomizers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_randomizers_on_user_id"
  end

  create_table "results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "roll_id", null: false
    t.datetime "updated_at", null: false
    t.integer "value"
    t.index ["roll_id"], name: "index_results_on_roll_id"
  end

  create_table "rolls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dice"
    t.string "name"
    t.integer "randomizer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["randomizer_id"], name: "index_rolls_on_randomizer_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "randomizers", "users"
  add_foreign_key "results", "rolls"
  add_foreign_key "rolls", "randomizers"
end
