class CreateCommittees < ActiveRecord::Migration
  def self.up
    create_table :committees do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :committees
  end
end
