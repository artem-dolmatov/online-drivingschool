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

ActiveRecord::Schema.define(version: 20170130170508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "question_id"
    t.integer  "correct"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "edu_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entity_files", force: :cascade do |t|
    t.string   "entity"
    t.integer  "entity_id"
    t.string   "name"
    t.string   "file"
    t.integer  "main"
    t.string   "title"
    t.string   "content_type"
    t.string   "original_filename"
    t.string   "size"
    t.text     "desc"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "entity_files", ["user_id"], name: "index_entity_files_on_user_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.string   "theme"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "phone"
  end

  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "name"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "weight"
    t.integer  "group"
  end

  add_index "questions", ["topic_id"], name: "index_questions_on_topic_id", using: :btree

  create_table "questions_edu_categories", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "edu_category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schools", ["city_id"], name: "index_schools_on_city_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "weight"
    t.integer  "exam"
    t.integer  "ticket",     default: 0
  end

  create_table "user_auth_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "devise"
    t.string   "devise_token"
    t.string   "devise_type"
    t.string   "auth_token"
    t.integer  "notify"
    t.datetime "expiration_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_auth_tokens", ["user_id"], name: "index_user_auth_tokens_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.string   "name"
    t.string   "ru_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_topics", ["topic_id"], name: "index_user_topics_on_topic_id", using: :btree
  add_index "user_topics", ["user_id"], name: "index_user_topics_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
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
    t.integer  "user_status_id"
    t.integer  "user_role_id"
    t.string   "first_name"
    t.string   "second_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "phone"
    t.integer  "city_id"
    t.integer  "school_id"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["school_id"], name: "index_users_on_school_id", using: :btree

  create_table "users_edu_categories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "edu_category_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "entity_files", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "questions", "topics"
  add_foreign_key "schools", "cities"
  add_foreign_key "user_auth_tokens", "users"
  add_foreign_key "user_topics", "topics"
  add_foreign_key "user_topics", "users"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "schools"
end
