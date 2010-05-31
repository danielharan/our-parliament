class NormalizeProvinces < ActiveRecord::Migration
  def self.up
    add_column :mps, :province_id, :integer
    add_column :senators, :province_id, :integer
    
    data_file = File.join(RAILS_ROOT, 'db', 'province_data', 'provinces.csv')
    FasterCSV.foreach(data_file, :encoding => 'U', :headers => true, :return_headers => false, :header_converters => :symbol, :converters => :all) do |row|
      province = Province.new({
        :name_en => row[:name_en],
        :name_fr => row[:name_fr]
      })
      province.save
      
    end
    
    remove_column :mps, :constituency_province
    remove_column :senators, :province
  end

  def self.down
    add_column :mps, :constituency_province, :string
    add_column :senators, :province, :string
    
    Province.find(:all).each { |province|
      Mp.update_all("constituency_province = \"#{province.name_en}\"", ["province_id = ?", province.id])
      Senator.update_all("province = \"#{province.name_en}\"", ["province_id = ?", province.id])
    }
    Province.delete_all
    
    remove_column :mps, :province_id
    remove_column :senators, :province_id
  end
end
