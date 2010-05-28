class CreateElections < ActiveRecord::Migration
  def self.up
    create_table :elections do |t|
      t.string :name
      t.date :date
      t.timestamps
    end
  end

  def self.down
    drop_table :elections
  end
end
