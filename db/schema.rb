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
# It's strongly recommended to check this file into your version control system.
ActiveRecord::Schema.define(:version => 20130903161204) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "apid_users", :force => true do |t|
    t.string   "value"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "device"
  end

  create_table "apids", :force => true do |t|
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "driver_id"
  end

  create_table "drivers", :force => true do |t|
    t.string   "cedula",             :null => false
    t.string   "name",               :null => false
    t.string   "password",           :null => false
    t.integer  "taxi_id",            :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "cel_number"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "map_objects", :force => true do |t|
    t.string   "category"
    t.datetime "expire_date"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "expirable"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "panics", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "taxi_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "positions", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "taxi_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.integer  "taxi_id"
    t.string   "verification_code"
    t.string   "address"
    t.string   "state"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "tip"
    t.string   "service_type"
  end

  create_table "taxis", :force => true do |t|
    t.string   "installation_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "current_driver_id"
  end

  create_table "users", :force => true do |t|
    t.string   "phone_number"
    t.string   "name"
    t.string   "email"
    t.string   "image_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
