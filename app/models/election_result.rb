class ElectionResult < ActiveRecord::Base
  belongs_to :election
  belongs_to :mp
end
