class AddDetailsToSenators < ActiveRecord::Migration
  def self.up
    add_column :senators, :personal_website, :string
    add_column :senators, :party_website, :string
  end

  def self.down
    remove_column :senators, :personal_website
    remove_column :senators, :party_website
  end
end
