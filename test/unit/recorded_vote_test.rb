require 'test_helper'

class RecordedVoteTest < ActiveSupport::TestCase
  should_belong_to :vote
  should_belong_to :mp
  
  def test_default_stance
    assert_equal "Abstained", RecordedVote.new.stance
  end
end
