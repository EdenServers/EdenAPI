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

ActiveRecord::Schema.define(version: 20150722151728) do

  create_table "containers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "command"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "docker_container_id"
    t.integer  "image_id"
    t.boolean  "running",             default: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "environment_variables", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "container_id"
  end

  create_table "images", force: :cascade do |t|
    t.string   "docker_image_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "repo"
    t.boolean  "ready",           default: false
    t.string   "ports"
  end

  create_table "ports", force: :cascade do |t|
    t.integer  "host_port"
    t.integer  "container_port"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "container_id",   default: 0
    t.string   "port_type"
  end

end
