class Election < ActiveRecord::Base
  has_many :election_results
end
