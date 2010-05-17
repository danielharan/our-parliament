class CreateHansardStatements < ActiveRecord::Migration
  def self.up
    create_table :hansard_statements do |t|
      t.integer :hansard_id
      t.integer :member_id
      t.string :member_name
      t.integer :parliament
      t.integer :session
      t.datetime :time
      t.string :attribution
      t.string :heading
      t.string :topic
      t.text :text
      t.timestamps
    end
  end

  def self.down
    drop_table :hansard_statements
  end
end
