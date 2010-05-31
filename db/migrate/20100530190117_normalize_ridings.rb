class NormalizeRidings < ActiveRecord::Migration
  def self.up
    rename_column :mps, :ed_id, :riding_id
    rename_column :election_results, :edid, :riding_id
    
    data_file = File.join(RAILS_ROOT, 'db', 'riding_data', 'ridings.csv')
    FasterCSV.foreach(data_file, :encoding => 'U', :headers => true, :return_headers => false, :header_converters => :symbol, :converters => :all) do |row|
      riding = Riding.new({
        :name_en => row[:name_en],
        :name_fr => row[:name_fr]
      })
      riding.id = row[:id]
      province = Province.find_by_name_en(row[:province])
      riding.province = province if province
      riding.save
      Mp.update_all("province_id = \"#{province.id}\"", ["riding_id = ?", riding.id]) if province
    end
    
    remove_column :mps, :constituency_name
  end

  def self.down
    add_column :mps, :constituency_name, :string
    
    Riding.find(:all).each { |riding|
      Mp.update_all("constituency_name = \"#{riding.name_en}\"", ["riding_id = ?", riding.id])
    }
    Riding.delete_all
    
    rename_column :mps, :riding_id, :ed_id
    rename_column :election_results, :riding_id, :edid
  end
end
