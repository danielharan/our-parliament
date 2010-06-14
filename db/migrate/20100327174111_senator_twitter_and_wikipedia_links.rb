class SenatorTwitterAndWikipediaLinks < ActiveRecord::Migration
  def self.up
    add_column :senators, :twitter, :string
    add_column :senators, :wikipedia, :string
  end

  def self.down
    remove_column :senators, :wikipedia
    remove_column :senators, :twitter
  end
end
