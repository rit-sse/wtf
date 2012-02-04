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

ActiveRecord::Schema.define(:version => 20120203193937) do

  create_table "event_prices", :force => true do |t|
    t.integer  "event_id",                                 :null => false
    t.decimal  "price",      :precision => 8, :scale => 2, :null => false
    t.string   "name"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "description"
    t.string   "location"
    t.string   "short_name"
    t.string   "short_description"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.datetime "published_at"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.string   "content_type"
  end

  add_index "pages", ["ancestry"], :name => "index_pages_on_ancestry"

end
