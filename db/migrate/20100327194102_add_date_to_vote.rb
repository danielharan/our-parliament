class AddDateToVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :vote_date, :date
  end

  def self.down
    remove_column :votes, :vote_date
  end
end
