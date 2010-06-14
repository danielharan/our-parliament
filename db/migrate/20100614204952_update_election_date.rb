class UpdateElectionDate < ActiveRecord::Migration
  def self.up
    election = Election.find_by_name("40th Federal Election")
    election.date = Date.civil(2008, 10, 14)
    election.save
  end

  def self.down
  end
end
