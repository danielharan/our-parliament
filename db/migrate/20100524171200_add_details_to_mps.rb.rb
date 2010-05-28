class AddDetailsToMps < ActiveRecord::Migration
  def self.up
    add_column :mps, :date_of_birth, :date
    add_column :mps, :place_of_birth, :string
  end

  def self.down
    remove_column :mps, :date_of_birth
    remove_column :mps, :place_of_birth
  end
end
