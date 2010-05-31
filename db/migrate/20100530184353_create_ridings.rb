class CreateRidings < ActiveRecord::Migration
  def self.up
    create_table :ridings do |t|
      t.string :name_en
      t.string :name_fr
      t.integer :province_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ridings
  end
end
