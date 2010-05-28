class CreateCommitteeMemberships < ActiveRecord::Migration
  def self.up
    create_table :committee_memberships do |t|
      t.integer :mp_id
      t.integer :committee_id
      t.string :role
      t.integer :parliament
      t.integer :session
    end
  end

  def self.down
    drop_table :committee_memberships
  end
end
