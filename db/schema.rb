# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100327194102) do

  create_table "mps", :force => true do |t|
    t.string  "ed_id"
    t.string  "parl_gc_id"
    t.string  "parl_gc_constituency_id"
    t.string  "constituency_name"
    t.string  "party"
    t.string  "name"
    t.string  "email"
    t.string  "website"
    t.string  "parliamentary_phone"
    t.string  "parliamentary_fax"
    t.string  "preferred_language"
    t.string  "constituency_address"
    t.string  "constituency_city"
    t.string  "constituency_province"
    t.string  "constituency_postal_code"
    t.string  "constituency_phone"
    t.string  "constituency_fax"
    t.string  "wikipedia"
    t.string  "facebook"
    t.string  "twitter"
    t.boolean "active",                   :default => true
    t.string  "wikipedia_riding"
  end

  create_table "recorded_votes", :force => true do |t|
    t.integer  "vote_id"
    t.integer  "mp_id"
    t.string   "stance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "senators", :force => true do |t|
    t.string   "name"
    t.string   "affiliation"
    t.string   "province"
    t.date     "nomination_date"
    t.date     "retirement_date"
    t.string   "appointed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter"
    t.string   "wikipedia"
  end

  create_table "votes", :force => true do |t|
    t.integer  "parliament"
    t.integer  "session"
    t.integer  "number"
    t.text     "title"
    t.integer  "in_favour"
    t.integer  "opposed"
    t.integer  "paired"
    t.boolean  "passed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bill_number"
    t.string   "context"
    t.string   "sponsor"
    t.date     "vote_date"
  end

end
