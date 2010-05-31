class NormalizeParties < ActiveRecord::Migration
  def self.up
    add_column :mps, :party_id, :integer
    add_column :senators, :party_id, :integer
    add_column :election_results, :party_id, :integer
    
    data_file = File.join(RAILS_ROOT, 'db', 'party_data', 'parties.csv')
    FasterCSV.foreach(data_file, :encoding => 'U', :headers => true, :return_headers => false, :header_converters => :symbol, :converters => :all) do |row|
      party = Party.new({
        :name_en => row[:name_en],
        :name_fr => row[:name_fr]
      })
      party.save
      Mp.update_all("party_id = \"#{party.id}\"", ["party = ?", party.name_en])
      Senator.update_all("party_id = \"#{party.id}\"", ["affiliation = ?", party.name_en])
      ElectionResult.update_all("party_id = \"#{party.id}\"", ["party = ?", party.name_en])
    end
    
    remove_column :mps, :party
    remove_column :senators, :affiliation
    remove_column :election_results, :party
  end

  def self.down
    add_column :mps, :party, :string
    add_column :senators, :affiliation, :string
    add_column :election_results, :party, :string
    
    Party.find(:all).each { |party|
      Mp.update_all("party = \"#{party.name_en}\"", ["party_id = ?", party.id])
      Senator.update_all("affiliation = \"#{party.name_en}\"", ["party_id = ?", party.id])
      ElectionResult.update_all("party = \"#{party.name_en}\"", ["party_id = ?", party.id])
    }
    Party.delete_all
    
    remove_column :mps, :party_id
    remove_column :senators, :party_id
    remove_column :election_results, :party_id
  end
end
