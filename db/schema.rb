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

ActiveRecord::Schema.define(:version => 20100310043209) do

  create_table "mps", :force => true do |t|
    t.string "ed_id"
    t.string "parl_gc_id"
    t.string "parl_gc_constituency_id"
    t.string "constituency_name"
    t.string "party"
    t.string "name"
    t.string "email"
    t.string "website"
    t.string "parliamentary_phone"
    t.string "parliamentary_fax"
    t.string "preferred_language"
    t.string "constituency_address"
    t.string "constituency_city"
    t.string "constituency_province"
    t.string "constituency_postal_code"
    t.string "constituency_phone"
    t.string "constituency_fax"
  end

end
