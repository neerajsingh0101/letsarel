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

ActiveRecord::Schema.define(:version => 20120718014944) do

  create_table "collaborations", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "person_id"
    t.string   "role"
    t.float    "paid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "collaborations", ["movie_id"], :name => "index_collaborations_on_movie_id"
  add_index "collaborations", ["person_id"], :name => "index_collaborations_on_person_id"

  create_table "distributors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.float    "budget"
    t.float    "revenue"
    t.date     "released_on"
    t.string   "genre"
    t.integer  "distributor_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "movies", ["distributor_id"], :name => "index_movies_on_distributor_id"

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "production_houses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "productions", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "production_house_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "productions", ["movie_id"], :name => "index_productions_on_movie_id"
  add_index "productions", ["production_house_id"], :name => "index_productions_on_production_house_id"

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
