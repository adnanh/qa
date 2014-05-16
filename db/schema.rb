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

ActiveRecord::Schema.define(version: 20140516020740) do

  create_table "answers", force: true do |t|
    t.integer  "author_id",                   null: false
    t.integer  "editor_id"
    t.integer  "question_id",                 null: false
    t.text     "content",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",    default: false, null: false
  end

  add_index "answers", ["author_id"], name: "answers_author_id_fk", using: :btree
  add_index "answers", ["editor_id"], name: "answers_editor_id_fk", using: :btree
  add_index "answers", ["question_id"], name: "answers_question_id_fk", using: :btree

  create_table "logs", force: true do |t|
    t.string   "ip_address",  limit: 15, null: false
    t.string   "description",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "password_recovery_tokens", force: true do |t|
    t.integer  "user_id",                  null: false
    t.string   "recovery_hash", limit: 32, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "password_recovery_tokens", ["recovery_hash"], name: "index_password_recovery_tokens_on_recovery_hash", unique: true, using: :btree
  add_index "password_recovery_tokens", ["user_id"], name: "index_password_recovery_tokens_on_user_id", unique: true, using: :btree

  create_table "private_messages", force: true do |t|
    t.string   "title",           null: false
    t.text     "content",         null: false
    t.integer  "sender_id",       null: false
    t.integer  "receiver_id",     null: false
    t.integer  "sender_status",   null: false
    t.integer  "receiver_status", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "private_messages", ["receiver_id"], name: "private_messages_receiver_id_fk", using: :btree
  add_index "private_messages", ["sender_id"], name: "private_messages_sender_id_fk", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "author_id",                       null: false
    t.integer  "editor_id"
    t.string   "title",                           null: false
    t.text     "content",                         null: false
    t.string   "tags",                            null: false
    t.boolean  "open",                            null: false
    t.integer  "views",                           null: false
    t.string   "status_description", limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["author_id"], name: "questions_author_id_fk", using: :btree
  add_index "questions", ["editor_id"], name: "questions_editor_id_fk", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "user_privileges", force: true do |t|
    t.string   "name",        limit: 45, null: false
    t.string   "description",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_privileges", ["name"], name: "index_user_privileges_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "username",               limit: 16,                 null: false
    t.string   "flair",                             default: ""
    t.boolean  "banned",                            default: false, null: false
    t.integer  "karma",                             default: 0,     null: false
    t.boolean  "email_public",                      default: false, null: false
    t.integer  "user_privilege_id",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_privilege_id"], name: "users_user_privilege_id_fk", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.boolean  "value",          null: false
    t.integer  "user_id",        null: false
    t.integer  "disqsable_id"
    t.string   "disqsable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id"], name: "votes_user_id_fk", using: :btree

  add_foreign_key "answers", "questions", name: "answers_question_id_fk"
  add_foreign_key "answers", "users", name: "answers_author_id_fk", column: "author_id"
  add_foreign_key "answers", "users", name: "answers_editor_id_fk", column: "editor_id"

  add_foreign_key "password_recovery_tokens", "users", name: "password_recovery_token_user_id_fk"

  add_foreign_key "private_messages", "users", name: "private_messages_receiver_id_fk", column: "receiver_id"
  add_foreign_key "private_messages", "users", name: "private_messages_sender_id_fk", column: "sender_id"

  add_foreign_key "questions", "users", name: "questions_author_id_fk", column: "author_id"
  add_foreign_key "questions", "users", name: "questions_editor_id_fk", column: "editor_id"

  add_foreign_key "users", "user_privileges", name: "users_user_privilege_id_fk"

  add_foreign_key "votes", "users", name: "votes_user_id_fk"

end
