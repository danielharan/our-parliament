require 'test_helper'

class RecordedVoteTest < ActiveSupport::TestCase
  should_belong_to :vote
  should_belong_to :mp
end
