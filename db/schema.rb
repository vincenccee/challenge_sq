# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_06_12_232251) do

  create_table "disbursements", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.decimal "fee", precision: 8, scale: 2, null: false
    t.date "disbursement_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "title", null: false
    t.string "email", null: false
    t.date "live_on", null: false
    t.integer "disbursement_frequency", default: 0
    t.float "minimum_monthly_fee", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "minimum_monthly_charges", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.decimal "amount", null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_minimum_monthly_charges_on_merchant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.date "purchased_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "disbursement_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  add_foreign_key "minimum_monthly_charges", "merchants"
end
