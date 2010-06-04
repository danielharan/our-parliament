class CommitteeMembership < ActiveRecord::Base
  belongs_to :mp
  belongs_to :committee
  belongs_to :committee_role
end
