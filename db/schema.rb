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

ActiveRecord::Schema.define(:version => 20110513101758) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "houses", :force => true do |t|
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
    t.string   "image_url"
    t.text     "description"
    t.string   "title"
    t.integer  "daft_id"
  end

  add_index "houses", ["county"], :name => "index_houses_on_county"
  add_index "houses", ["daft_id"], :name => "index_houses_on_daft_id"
  add_index "houses", ["price"], :name => "index_houses_on_price"

  create_table "rates", :force => true do |t|
    t.float    "initial_rate"
    t.string   "lender"
    t.string   "loan_type"
    t.integer  "min_ltv"
    t.integer  "max_ltv"
    t.integer  "initial_period_length"
    t.float    "rolls_to"
    t.integer  "max_princ"
    t.integer  "min_princ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_deposit"
    t.integer  "max_deposit"
    t.float    "twenty_year_apr"
  end

  create_table "searches", :force => true do |t|
    t.integer  "max_payment"
    t.integer  "deposit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
    t.integer  "min_payment"
    t.integer  "term"
    t.string   "loan_type"
    t.integer  "initial_period_length"
    t.string   "lender"
    t.integer  "max_price"
    t.integer  "min_price"
    t.integer  "rate_id"
  end

end
