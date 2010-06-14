class MpInfo < ActiveRecord::Migration
  def self.up
    add_column :mps, :wikipedia, :string
    add_column :mps, :facebook, :string
    add_column :mps, :twitter, :string
  end

  def self.down
    remove_column :mps, :twitter
    remove_column :mps, :facebook
    remove_column :mps, :wikipedia
  end
end
