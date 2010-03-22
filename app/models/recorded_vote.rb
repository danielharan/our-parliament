class RecordedVote < ActiveRecord::Base
  belongs_to :vote
  belongs_to :mp
end
