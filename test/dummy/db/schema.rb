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

ActiveRecord::Schema.define(version: 20160202164325) do

  create_table "documentation_editor_images", force: :cascade do |t|
    t.string   "caption"
    t.datetime "created_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "documentation_editor_pages", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "slug"
    t.datetime "created_at",                        null: false
    t.integer  "published_revision_id"
    t.string   "title",                 limit: 255
    t.integer  "thumbnail_id"
    t.string   "languages"
    t.string   "description"
    t.string   "section"
  end

  add_index "documentation_editor_pages", ["slug"], name: "index_documentation_editor_pages_on_slug"
  add_index "documentation_editor_pages", ["slug"], name: "index_documentation_editor_pages_on_slug_and_preview"

  create_table "documentation_editor_revisions", force: :cascade do |t|
    t.integer  "page_id",                     null: false
    t.integer  "author_id"
    t.text     "content",    limit: 16777215
    t.datetime "created_at",                  null: false
  end

end
