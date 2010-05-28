require 'fastercsv'

class LoadElectionResults < ActiveRecord::Migration
  def self.up
    election = Election.find_or_create_by_name("40th Federal Election")
    election.date = Date.civil(2006, 1, 23)
    election.save
    
    data_file = File.join(RAILS_ROOT, 'db', 'election_data', '40th_federal_election.csv')
    FasterCSV.foreach(data_file, :encoding => 'N', :headers => true, :return_headers => false, :header_converters => :symbol, :converters => :all) do |row|
      mp = Mp.find_by_name_and_ed_id(row[:candidate], row[:edid])
      result = ElectionResult.new
      result.election = election
      result.candidate = row[:candidate]
      result.mp = mp if mp
      result.edid = row[:edid]
      result.party = row[:party_en]
      result.vote_total = row[:votes_obtained]
      result.vote_percentage = row[:percentage_of_votes_obtained]
      result.majority = row[:majority] if row[:majority]
      result.save
    end
  end

  def self.down
  end
end
