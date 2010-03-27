class LengthenBillTitleInVotes < ActiveRecord::Migration
  def self.up
    change_column :votes, :title, :text
    change_column :votes, :context, :text
  end

  def self.down
    change_column :votes, :title, :string
    change_column :votes, :context, :string
  end
end
