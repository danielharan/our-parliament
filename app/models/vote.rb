class Vote < ActiveRecord::Base
  has_many :recorded_votes
end
