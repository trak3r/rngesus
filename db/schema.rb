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

ActiveRecord::Schema[8.1].define(version: 2025_11_25_113848) do
  create_table "examples", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "value"
  end

  create_table "randomizer_tags", force: :cascade do |t|
    t.integer "randomizer_id", null: false
    t.integer "tag_id", null: false
    t.index ["randomizer_id", "tag_id"], name: "index_randomizer_tags_on_randomizer_id_and_tag_id", unique: true
  end

  create_table "randomizers", force: :cascade do |t|
    t.integer "cached_votes_down", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_up", default: 0
    t.datetime "created_at", null: false
    t.string "name"
    t.string "slug", limit: 5, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["slug"], name: "index_randomizers_on_slug", unique: true
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

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "nickname"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "votable_id"
    t.string "votable_type"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.integer "voter_id"
    t.string "voter_type"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end

  add_foreign_key "randomizers", "users"
  add_foreign_key "results", "rolls"
  add_foreign_key "rolls", "randomizers"
end
