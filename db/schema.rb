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

ActiveRecord::Schema.define(version: 20160224182901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contents", force: :cascade do |t|
    t.integer  "document_id"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "contents", ["document_id"], name: "index_contents_on_document_id", using: :btree

  create_table "details", force: :cascade do |t|
    t.integer  "document_id"
    t.jsonb    "meta",        default: {}, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "details", ["document_id"], name: "index_details_on_document_id", using: :btree
  add_index "details", ["meta"], name: "index_details_on_meta", using: :gin

  create_table "document_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "document_types", ["name"], name: "index_document_types_on_name", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.string   "seo_url"
    t.integer  "document_type_id"
    t.integer  "status_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "documents", ["document_type_id"], name: "index_documents_on_document_type_id", using: :btree
  add_index "documents", ["seo_url"], name: "index_documents_on_seo_url", using: :btree
  add_index "documents", ["status_id"], name: "index_documents_on_status_id", using: :btree

  create_table "homepages", force: :cascade do |t|
    t.integer  "document_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "homepages", ["document_id"], name: "index_homepages_on_document_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "up_vote"
    t.integer  "down_vote"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "ratings", ["document_id"], name: "index_ratings_on_document_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "statuses", ["name"], name: "index_statuses_on_name", using: :btree

end
