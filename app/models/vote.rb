class Vote < ActiveRecord::Base
  has_many :recorded_votes
  
  index do
    bill_number 'A' # high priority
    title
    context
    sponsor
  end
  
  def self.last(n)
    find(:all, :order => "vote_date DESC", :limit => n)
  end
  
  def total_votes
    in_favour + opposed + paired
  end
end
