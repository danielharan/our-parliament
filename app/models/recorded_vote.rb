class RecordedVote < ActiveRecord::Base
  belongs_to :vote
  belongs_to :mp
  
  def stance
    read_attribute(:stance) || "Abstained"
  end
end
