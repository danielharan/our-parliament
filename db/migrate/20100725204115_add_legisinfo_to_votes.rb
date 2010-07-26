class AddLegisinfoToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :legisinfo_bill_id, :integer
  end

  def self.down
    remove_column :votes, :legisinfo_bill_id
  end
end
