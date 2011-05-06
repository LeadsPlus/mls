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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110506153655) do

  create_table "houses", :force => true do |t|
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.text     "description"
    t.string   "title"
    t.integer  "county_id"
    t.string   "daft_url"
  end

  create_table "rates", :force => true do |t|
    t.float    "initial_rate"
    t.string   "lender"
    t.string   "type"
    t.integer  "min_depos"
    t.integer  "initial_period_length"
    t.float    "svr"
    t.integer  "max_princ"
    t.integer  "min_princ"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "max_payment"
    t.integer  "deposit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_payment"
    t.integer  "term"
    t.integer  "county_id"
  end

end
