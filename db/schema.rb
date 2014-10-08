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

ActiveRecord::Schema.define(version: 20141007212523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agendas", force: true do |t|
    t.integer  "workout_id"
    t.integer  "exercise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "set"
    t.integer  "rep"
    t.string   "weight"
    t.string   "repdone"
    t.string   "setdone"
    t.string   "weightdone"
  end

  create_table "appointments", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trainer_id"
    t.integer  "client_id"
    t.string   "allowjoin"
    t.string   "maxjoin"
  end

  create_table "availables", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "start_at"
    t.string   "end_at"
    t.string   "day_of_week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trainer_id"
  end

  create_table "cats", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trainer_id"
    t.integer  "age"
    t.string   "gender"
    t.string   "email"
    t.string   "phone"
    t.text     "notes"
    t.integer  "row_order"
  end

  create_table "exercises", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "trainer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "measure"
  end

  create_table "meetups", force: true do |t|
    t.integer  "client_id"
    t.integer  "appointment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.text     "description"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "trainer_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", force: true do |t|
    t.string   "repsdone"
    t.string   "weightdone"
    t.string   "unitdone"
    t.integer  "rotation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_id"
  end

  create_table "rotations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "amount"
    t.integer  "agenda_id"
    t.string   "unit"
    t.string   "exwt"
    t.string   "amountdone"
    t.string   "weightdone"
  end

  create_table "trainers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unavailables", force: true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "trainer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_card_token"
    t.string   "plan"
    t.string   "stripe_customer_token"
    t.string   "stripe_publishable_key"
    t.string   "access_token"
    t.integer  "rolable_id"
    t.string   "rolable_type"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workouts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trainer_id"
    t.integer  "client_id"
    t.integer  "appointment_id"
  end

end
