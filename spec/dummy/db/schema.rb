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

ActiveRecord::Schema.define(version: 2020_05_29_161449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "wait_for_me_groups", force: :cascade do |t|
    t.string "group_key", null: false
    t.string "job_id"
    t.string "execute_after_waiting"
    t.string "execute_after_waiting_params", array: true
    t.integer "expected_number_of_participants"
    t.integer "wait_time_in_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_key"], name: "index_wait_for_me_groups_on_group_key", unique: true
  end

  create_table "wait_for_me_participants", force: :cascade do |t|
    t.string "participant_key", null: false
    t.string "group_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_key"], name: "index_wait_for_me_participants_on_participant_key", unique: true
  end

end
