class CreateParliamentaryFunctions < ActiveRecord::Migration
  def self.up
    create_table :parliamentary_functions do |t|
      t.integer :mp_id
      t.string :role
      t.string :title
      t.date :start
      t.date :end
    end
  end

  def self.down
    drop_table :parliamentary_functions
  end
end
