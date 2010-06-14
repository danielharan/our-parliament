class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes, :force => true do |t|
      t.integer :parliament
      t.integer :session
      t.integer :number
      t.string  :title
      t.integer :in_favour
      t.integer :opposed
      t.integer :paired
      t.boolean :passed
      t.timestamps
    end
    
    create_table :recorded_votes, :force => true do |t|
      t.belongs_to :vote
      t.belongs_to :mp
      t.string     :stance
      t.timestamps
    end
  end

  def self.down
    drop_table :recorded_votes
    drop_table :votes
  end
end
