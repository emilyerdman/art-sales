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

ActiveRecord::Schema.define(version: 20190305172518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "dates"
    t.string "category"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "description"
    t.string "first_name"
    t.string "last_name"
    t.string "institution"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state_prov"
    t.string "postal_code"
  end

  create_table "works", force: :cascade do |t|
    t.string "inventory_number"
    t.string "title"
    t.string "art_type"
    t.string "full_year"
    t.string "media"
    t.integer "hinw"
    t.integer "hinn"
    t.integer "hind"
    t.integer "winw"
    t.integer "winn"
    t.integer "wind"
    t.integer "dinw"
    t.integer "dinn"
    t.integer "dind"
    t.string "numerator"
    t.string "denominator"
    t.string "set"
    t.decimal "base_net_amount"
    t.decimal "base_purchase_price"
    t.decimal "retail_value"
    t.string "category"
    t.string "image"
    t.boolean "framed"
    t.string "frame_condition"
    t.integer "current_owner"
    t.boolean "sold"
    t.boolean "erdman"
    t.bigint "contact_id"
    t.bigint "artist_id"
    t.string "location"
    t.string "bin"
    t.boolean "corporate_collection"
    t.index ["artist_id"], name: "index_works_on_artist_id"
    t.index ["contact_id"], name: "index_works_on_contact_id"
  end

  add_foreign_key "works", "artists"
  add_foreign_key "works", "contacts"
end
