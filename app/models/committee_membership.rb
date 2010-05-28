class CommitteeMembership < ActiveRecord::Base
  belongs_to :mp
  belongs_to :committee
end
