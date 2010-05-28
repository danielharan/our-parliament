class Committee < ActiveRecord::Base
  has_many :members, :class_name => "CommitteeMembership", :include => "mp"
end
