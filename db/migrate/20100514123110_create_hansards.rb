class CreateHansards < ActiveRecord::Migration
  def self.up
    create_table :hansards do |t|
      t.date :date
      t.integer :num
      t.integer :parliament
      t.integer :session
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :hansards
  end
end
