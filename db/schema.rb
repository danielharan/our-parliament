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

ActiveRecord::Schema.define(:version => 20100726112629) do

  create_table "committee_memberships", :force => true do |t|
    t.integer "mp_id"
    t.integer "committee_id"
    t.integer "parliament"
    t.integer "session"
    t.integer "committee_role_id"
  end

  create_table "committee_roles", :force => true do |t|
    t.string   "name_en"
    t.string   "name_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committees", :force => true do |t|
    t.string  "name_en"
    t.string  "name_fr"
    t.string  "acronym"
    t.integer "subcommittee_of"
  end

  create_table "election_results", :force => true do |t|
    t.integer  "election_id"
    t.string   "candidate"
    t.integer  "mp_id"
    t.integer  "riding_id"
    t.integer  "vote_total"
    t.float    "vote_percentage"
    t.integer  "majority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "party_id"
  end

  create_table "elections", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hansard_statements", :force => true do |t|
    t.integer  "hansard_id"
    t.integer  "member_id"
    t.string   "member_name"
    t.integer  "parliament"
    t.integer  "session"
    t.datetime "time"
    t.string   "attribution"
    t.string   "heading"
    t.string   "topic"
    t.text     "text",        :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hansards", :force => true do |t|
    t.date     "date"
    t.integer  "num"
    t.integer  "parliament"
    t.integer  "session"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "category"
    t.string   "url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale"
  end

  create_table "mps", :force => true do |t|
    t.string   "riding_id"
    t.string   "parl_gc_id"
    t.string   "parl_gc_constituency_id"
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.string   "parliamentary_phone"
    t.string   "parliamentary_fax"
    t.string   "preferred_language"
    t.string   "constituency_address"
    t.string   "constituency_city"
    t.string   "constituency_postal_code"
    t.string   "constituency_phone"
    t.string   "constituency_fax"
    t.string   "wikipedia"
    t.string   "facebook"
    t.string   "twitter"
    t.boolean  "active",                   :default => true
    t.string   "wikipedia_riding"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.date     "date_of_birth"
    t.string   "place_of_birth"
    t.integer  "party_id"
    t.integer  "province_id"
    t.date     "start_date"
  end

  create_table "mps_news_articles", :id => false, :force => true do |t|
    t.integer "mp_id"
    t.integer "news_article_id"
  end

  create_table "news_articles", :force => true do |t|
    t.string   "url",     :limit => 1024
    t.string   "title",   :limit => 1024
    t.string   "source"
    t.datetime "date"
    t.text     "summary"
  end

  create_table "parliamentary_functions", :force => true do |t|
    t.integer "mp_id"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "parliamentary_title_id"
  end

  create_table "parliamentary_titles", :force => true do |t|
    t.string   "name_en"
    t.string   "name_fr"
    t.string   "role_en"
    t.string   "role_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", :force => true do |t|
    t.string   "name_en"
    t.string   "name_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "provinces", :force => true do |t|
    t.string   "name_en"
    t.string   "name_fr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recorded_votes", :force => true do |t|
    t.integer  "vote_id"
    t.integer  "mp_id"
    t.string   "stance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ridings", :force => true do |t|
    t.string   "name_en"
    t.string   "name_fr"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "senators", :force => true do |t|
    t.string   "name"
    t.date     "nomination_date"
    t.date     "retirement_date"
    t.string   "appointed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter"
    t.string   "wikipedia"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "personal_website"
    t.string   "party_website"
    t.integer  "party_id"
    t.integer  "province_id"
  end

  create_table "senators_news_articles", :id => false, :force => true do |t|
    t.integer "senator_id"
    t.integer "news_article_id"
  end

  create_table "tweets", :force => true do |t|
    t.integer  "mp_id"
    t.integer  "twitter_id", :limit => 8
    t.string   "text"
    t.datetime "created_at"
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
    t.text     "context"
    t.text     "sponsor"
    t.date     "vote_date"
    t.integer  "legisinfo_bill_id"
  end

end
