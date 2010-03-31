require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  should_have_many :recorded_votes
  
  def test_total_votes
    v = Factory(:vote, :in_favour => 100, :opposed => 10, :paired => 2)
    
    assert_equal 112, v.total_votes
  end
end
