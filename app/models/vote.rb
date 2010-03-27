class Vote < ActiveRecord::Base
  has_many :recorded_votes
  
  def self.last(n)
    find(:all, :order => "vote_date DESC", :limit => n)
  end
end
