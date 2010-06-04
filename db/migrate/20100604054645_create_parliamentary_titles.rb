class CreateParliamentaryTitles < ActiveRecord::Migration
  def self.up
    create_table :parliamentary_titles do |t|
      t.string :name_en
      t.string :name_fr
      t.string :role_en
      t.string :role_fr
      t.timestamps
    end
  end

  def self.down
    drop_table :parliamentary_titles
  end
end
