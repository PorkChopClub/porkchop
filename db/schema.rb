# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150219035315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.integer  "home_player_id"
    t.integer  "away_player_id"
    t.integer  "victor_id"
    t.datetime "finalized_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "first_service_by_home_player", default: true
  end

  add_index "matches", ["away_player_id"], name: "index_matches_on_away_player_id", using: :btree
  add_index "matches", ["home_player_id"], name: "index_matches_on_home_player_id", using: :btree
  add_index "matches", ["victor_id"], name: "index_matches_on_victor_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "points", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "victor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "points", ["match_id"], name: "index_points_on_match_id", using: :btree
  add_index "points", ["victor_id"], name: "index_points_on_victor_id", using: :btree

  add_foreign_key "matches", "players", column: "away_player_id"
  add_foreign_key "matches", "players", column: "home_player_id"
  add_foreign_key "matches", "players", column: "victor_id"
  add_foreign_key "points", "matches"
  add_foreign_key "points", "players", column: "victor_id"
end
