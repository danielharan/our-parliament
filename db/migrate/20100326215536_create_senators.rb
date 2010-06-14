class CreateSenators < ActiveRecord::Migration
  def self.up
    create_table :senators do |t|
      t.string :name
      t.string :affiliation
      t.string :province
      t.date :nomination_date
      t.date :retirement_date
      t.string :appointed_by

      t.timestamps
    end
  end

  def self.down
    drop_table :senators
  end
end
