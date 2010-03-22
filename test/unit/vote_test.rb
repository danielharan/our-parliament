require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  should_have_many :recorded_votes
end
