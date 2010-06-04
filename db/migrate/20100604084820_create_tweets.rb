class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :mp_id
      t.integer :twitter_id, :limit => 8
      t.string :text
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :tweets
  end
end
