class CreateCommitteeRoles < ActiveRecord::Migration
  def self.up
    create_table :committee_roles do |t|
      t.string :name_en
      t.string :name_fr
      t.timestamps
    end
  end

  def self.down
    drop_table :committee_roles
  end
end
