class AddWpRidingPage < ActiveRecord::Migration
  def self.up
    add_column :mps, :wikipedia_riding, :string
  end

  def self.down
    remove_column :mps, :wikipedia_riding
  end
end
