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

ActiveRecord::Schema.define(version: 20170421153350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.text     "up_votes",   default: [],              array: true
    t.text     "down_votes", default: [],              array: true
    t.integer  "user_id"
    t.integer  "note_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "comment_id"
    t.integer  "parent_id"
    t.index ["note_id"], name: "index_comments_on_note_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "code"
    t.text     "description", default: ""
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "note_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_favorites_on_user_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.text     "up_votes",   default: [],              array: true
    t.text     "down_votes", default: [],              array: true
    t.text     "whitelist",  default: [],              array: true
    t.text     "image_urls", default: [],              array: true
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["course_id"], name: "index_notes_on_course_id", using: :btree
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "notes_tags", force: :cascade do |t|
    t.integer  "note_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_notes_tags_on_note_id", using: :btree
    t.index ["tag_id"], name: "index_notes_tags_on_tag_id", using: :btree
  end

  create_table "privileges", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "photo"
    t.integer  "points",            default: 0
    t.integer  "privilege",         default: 1
    t.text     "favorites",         default: [],                array: true
    t.integer  "default_course_id"
    t.integer  "location_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "is_active",         default: true
  end

  add_foreign_key "comments", "notes"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "users"
  add_foreign_key "notes", "courses"
  add_foreign_key "notes", "users"
  add_foreign_key "notes_tags", "notes"
  add_foreign_key "notes_tags", "tags"
end
