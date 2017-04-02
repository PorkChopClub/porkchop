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

ActiveRecord::Schema.define(version: 20170402062910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "betting_infos", force: :cascade do |t|
    t.integer  "match_id",                             null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.decimal  "spread",       precision: 3, scale: 1
    t.integer  "favourite_id"
    t.index ["favourite_id"], name: "index_betting_infos_on_favourite_id", using: :btree
    t.index ["match_id"], name: "index_betting_infos_on_match_id", using: :btree
  end

  create_table "elo_ratings", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "match_id",   null: false
    t.index ["match_id"], name: "index_elo_ratings_on_match_id", using: :btree
    t.index ["player_id", "created_at"], name: "index_elo_ratings_on_player_id_and_created_at", using: :btree
    t.index ["player_id"], name: "index_elo_ratings_on_player_id", using: :btree
  end

  create_table "experiences", force: :cascade do |t|
    t.integer  "xp",          null: false
    t.string   "reason",      null: false
    t.string   "source_type", null: false
    t.integer  "source_id",   null: false
    t.integer  "player_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["player_id"], name: "index_experiences_on_player_id", using: :btree
    t.index ["reason", "source_id", "source_type"], name: "index_experiences_on_reason_and_source_id_and_source_type", unique: true, using: :btree
    t.index ["source_id"], name: "index_experiences_on_source_id", using: :btree
    t.index ["source_type", "source_id"], name: "index_experiences_on_source_type_and_source_id", using: :btree
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "table_id"
    t.index ["table_id"], name: "index_leagues_on_table_id", using: :btree
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "home_player_id"
    t.integer  "away_player_id"
    t.integer  "victor_id"
    t.datetime "finalized_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "first_service"
    t.integer  "table_id"
    t.index ["away_player_id"], name: "index_matches_on_away_player_id", using: :btree
    t.index ["finalized_at"], name: "index_matches_on_finalized_at", using: :btree
    t.index ["home_player_id"], name: "index_matches_on_home_player_id", using: :btree
    t.index ["table_id"], name: "index_matches_on_table_id", using: :btree
    t.index ["victor_id"], name: "index_matches_on_victor_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.string   "legacy_avatar_url",      default: "http://i.imgur.com/ya5NxSH.png"
    t.string   "nickname"
    t.boolean  "active",                 default: false
    t.string   "email",                  default: "",                               null: false
    t.string   "encrypted_password",     default: "",                               null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                                null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "profile_picture"
    t.boolean  "admin",                  default: false,                            null: false
    t.index ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_players_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true, using: :btree
  end

  create_table "points", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "victor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_points_on_match_id", using: :btree
    t.index ["victor_id"], name: "index_points_on_victor_id", using: :btree
  end

  create_table "season_matches", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_season_matches_on_match_id", using: :btree
    t.index ["season_id"], name: "index_season_matches_on_season_id", using: :btree
  end

  create_table "season_memberships", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_season_memberships_on_player_id", using: :btree
    t.index ["season_id"], name: "index_season_memberships_on_season_id", using: :btree
  end

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
    t.index ["player_id"], name: "index_streaks_on_player_id", using: :btree
  end

  create_table "tables", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "betting_infos", "matches"
  add_foreign_key "betting_infos", "players", column: "favourite_id"
  add_foreign_key "elo_ratings", "matches"
  add_foreign_key "elo_ratings", "players"
  add_foreign_key "experiences", "players"
  add_foreign_key "leagues", "tables"
  add_foreign_key "matches", "players", column: "away_player_id"
  add_foreign_key "matches", "players", column: "home_player_id"
  add_foreign_key "matches", "players", column: "victor_id"
  add_foreign_key "matches", "tables"
  add_foreign_key "points", "matches"
  add_foreign_key "points", "players", column: "victor_id"
  add_foreign_key "season_matches", "matches"
  add_foreign_key "season_matches", "seasons"
  add_foreign_key "season_memberships", "players"
  add_foreign_key "season_memberships", "seasons"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "streaks", "players"
end
