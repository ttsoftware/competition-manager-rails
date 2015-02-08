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

ActiveRecord::Schema.define(version: 20150208134431) do

  create_table "associations", force: :cascade do |t|
    t.string "name"
  end

  create_table "athletes", force: :cascade do |t|
    t.string  "name"
    t.integer "birth_year"
    t.boolean "is_group"
    t.integer "association_id"
  end

  add_index "athletes", ["association_id"], name: "index_athletes_on_association_id"

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "competition_statletik_id"
  end

  create_table "disciplines", force: :cascade do |t|
    t.string  "name"
    t.string  "age_group"
    t.boolean "is_male"
    t.boolean "is_indoor"
  end

  create_table "results", force: :cascade do |t|
    t.string   "age_group"
    t.string   "discipline_name"
    t.datetime "date"
    t.float    "value"
    t.float    "wind"
    t.integer  "athlete_id"
    t.integer  "competition_id"
    t.integer  "discipline_id"
  end

  add_index "results", ["athlete_id"], name: "index_results_on_athlete_id"
  add_index "results", ["competition_id"], name: "index_results_on_competition_id"
  add_index "results", ["discipline_id"], name: "index_results_on_discipline_id"
  add_index "results", ["value", "wind", "athlete_id", "competition_id", "discipline_id"], name: "athlete_result", unique: true

end
