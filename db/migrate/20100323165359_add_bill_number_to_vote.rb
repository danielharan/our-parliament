class AddBillNumberToVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :bill_number, :string
    add_column :votes, :context, :string
    add_column :votes, :sponsor, :string
  end

  def self.down
    remove_column :votes, :sponsor
    remove_column :votes, :context
    remove_column :votes, :bill_number
  end
end
