require 'fastercsv'

class UpdateSenatorDetails < ActiveRecord::Migration
  def self.up
    data_file = File.join(RAILS_ROOT, 'db', 'senator_data', 'Senator Details.csv')
    FasterCSV.foreach(data_file, :encoding => 'N', :headers => true, :return_headers => false, :header_converters => :symbol, :converters => :all) do |row|
      senator = Senator.find_by_name(row[:name])
      if senator
        province = Province.find_by_name_en(row[:province])
        senator.province = province if province 
        party = Party.find_by_name_en(row[:affiliation])
        senator.party = party if party 
        senator.save
      end
    end
  end

  def self.down
  end
end
