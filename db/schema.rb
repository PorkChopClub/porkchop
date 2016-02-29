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

ActiveRecord::Schema.define(version: 20160229020715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "variety"
    t.integer  "rank",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "betting_infos", force: :cascade do |t|
    t.integer  "match_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "betting_infos", ["match_id"], name: "index_betting_infos_on_match_id", using: :btree

  create_table "elo_ratings", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "elo_ratings", ["player_id", "created_at"], name: "index_elo_ratings_on_player_id_and_created_at", using: :btree
  add_index "elo_ratings", ["player_id"], name: "index_elo_ratings_on_player_id", using: :btree

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "home_player_id"
    t.integer  "away_player_id"
    t.integer  "victor_id"
    t.datetime "finalized_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "first_service"
  end

  add_index "matches", ["away_player_id"], name: "index_matches_on_away_player_id", using: :btree
  add_index "matches", ["finalized_at"], name: "index_matches_on_finalized_at", using: :btree
  add_index "matches", ["home_player_id"], name: "index_matches_on_home_player_id", using: :btree
  add_index "matches", ["victor_id"], name: "index_matches_on_victor_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "avatar_url", default: "http://i.imgur.com/ya5NxSH.png"
    t.string   "nickname"
    t.boolean  "active",     default: false
  end

  create_table "points", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "victor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "points", ["match_id"], name: "index_points_on_match_id", using: :btree
  add_index "points", ["victor_id"], name: "index_points_on_victor_id", using: :btree

  create_table "rails_schema_migrations", id: false, force: :cascade do |t|
    t.string "version", null: false
  end

  add_index "rails_schema_migrations", ["version"], name: "unique_schema_migrations", unique: true, using: :btree

  create_table "season_matches", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "season_matches", ["match_id"], name: "index_season_matches_on_match_id", using: :btree
  add_index "season_matches", ["season_id"], name: "index_season_matches_on_season_id", using: :btree

  create_table "season_memberships", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "season_memberships", ["player_id"], name: "index_season_memberships_on_player_id", using: :btree
  add_index "season_memberships", ["season_id"], name: "index_season_memberships_on_season_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.integer  "games_per_matchup"
    t.datetime "finalized_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "league_id"
  end

  create_table "streaks", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "streak_type"
    t.integer  "streak_length"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "streaks", ["player_id"], name: "index_streaks_on_player_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "admin",      default: false
  end

  add_foreign_key "achievements", "players"
  add_foreign_key "betting_infos", "matches"
  add_foreign_key "elo_ratings", "players"
  add_foreign_key "matches", "players", column: "away_player_id"
  add_foreign_key "matches", "players", column: "home_player_id"
  add_foreign_key "matches", "players", column: "victor_id"
  add_foreign_key "points", "matches"
  add_foreign_key "points", "players", column: "victor_id"
  add_foreign_key "season_matches", "matches"
  add_foreign_key "season_matches", "seasons"
  add_foreign_key "season_memberships", "players"
  add_foreign_key "season_memberships", "seasons"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "streaks", "players"
end
