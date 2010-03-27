class AddActiveFlagToMps < ActiveRecord::Migration
  def self.up
    add_column :mps, :active, :boolean, :default => true
  end

  def self.down
    remove_column :mps, :active
  end
end
