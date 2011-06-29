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

ActiveRecord::Schema.define(:version => 20110629142939) do

  create_table "counties", :force => true do |t|
    t.integer  "daft_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "image_url"
    t.text     "description"
    t.string   "daft_title"
    t.integer  "daft_id"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.string   "address"
    t.string   "property_type"
    t.integer  "county_id"
    t.integer  "town_id"
    t.integer  "last_scrape"
    t.string   "property_type_uid"
    t.string   "region_name"
  end

  add_index "houses", ["daft_id"], :name => "index_houses_on_daft_id"
  add_index "houses", ["price"], :name => "index_houses_on_price"

  create_table "photos", :force => true do |t|
    t.integer  "house_id"
    t.string   "url"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["url"], :name => "index_photos_on_url", :unique => true

  create_table "property_types", :force => true do |t|
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_types", ["uid"], :name => "index_property_types_on_uid", :unique => true

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
    t.string   "lender_uid"
    t.string   "loan_type_uid"
  end

  create_table "searches", :force => true do |t|
    t.integer  "max_payment"
    t.integer  "deposit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locations",      :limit => 400
    t.integer  "min_payment"
    t.integer  "term"
    t.string   "loan_type_uids"
    t.string   "lender_uids"
    t.integer  "max_price"
    t.integer  "min_price"
    t.integer  "rate_id"
    t.string   "bedrooms"
    t.string   "bathrooms"
    t.string   "prop_type_uids"
    t.integer  "usage_id"
  end

  create_table "towns", :force => true do |t|
    t.string   "name"
    t.string   "daft_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
  end

  create_table "usages", :force => true do |t|
    t.string   "identifier", :limit => 32
    t.string   "user_agent"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
