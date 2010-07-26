class AddCommitteeAcronyms < ActiveRecord::Migration
  def self.up
    add_column :committees, :acronym, :string
    add_column :committees, :subcommittee_of, :integer
  end

  def self.down
    remove_column :committees, :acronym
    remove_column :committees, :subcommittee_of
  end
end
