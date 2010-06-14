class AddImagesToParties < ActiveRecord::Migration
  def self.up
    add_column :parties, :image, :string
    
    data_file = File.join(RAILS_ROOT, 'db', 'party_data', 'parties.csv')
    FasterCSV.foreach(data_file, :encoding => 'U', :headers => true, :return_headers => false, :header_converters => :symbol, :converters => :all) do |row|
      party = Party.find_by_name_en(row[:name_en])
      if party row[:image] and row[:image].length > 0
        party.image = row[:image]
        party.save
      else
        puts "Unmatched party: #{row[:name_en]} -> #{row[:image]}"
      end
    end
  end

  def self.down
    remove_column :parties, :image
  end
end
