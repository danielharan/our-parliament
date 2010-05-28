class CreateElectionResults < ActiveRecord::Migration
  def self.up
    create_table :election_results do |t|
      t.integer :election_id
      t.string :candidate
      t.string :party
      t.integer :mp_id
      t.integer :edid
      t.integer :vote_total
      t.float :vote_percentage
      t.integer :majority
      t.timestamps
    end
  end

  def self.down
    drop_table :election_results
  end
end
