class ChangeVoteFieldsToText < ActiveRecord::Migration
  def self.up
    change_column :votes, :context, :text
    change_column :votes, :sponsor, :text
  end

  def self.down
    change_column :votes, :context, :string
    change_column :votes, :sponsor, :string
  end
end
