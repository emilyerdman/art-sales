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

ActiveRecord::Schema.define(version: 20180406165900) do

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.decimal "shipping_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listings", force: :cascade do |t|
    t.string "site"
    t.datetime "start_datetime"
    t.datetime "sold_datetime"
    t.string "link"
    t.decimal "start_price"
    t.decimal "sale_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "piece_id"
    t.boolean "shipped"
    t.integer "buyer_id"
    t.index ["buyer_id"], name: "index_listings_on_buyer_id"
    t.index ["piece_id"], name: "index_listings_on_piece_id"
  end

  create_table "pieces", force: :cascade do |t|
    t.string "title"
    t.string "artist"
    t.date "date"
    t.float "purchase_price"
    t.string "picture"
    t.string "print_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
