require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  should_have_many :recorded_votes

  def test_build_vote
    v = VoteList.build_vote({"parliament"=>"40", "sitting"=>"128", "number"=>"158", "TotalYeas"=>"147", "date"=>"2009-12-10", "session"=>"2", "Decision"=>"Agreed to", "TotalNays"=>"142", "TotalPaired"=>"2", "Description"=>"Eighth Report of the Standing Committee on Fisheries and OceansHuitième rapport du Comité permanent des pêches et des océans"})
    
    assert_equal Vote, v.class
    assert_equal 142, v.opposed
  end

end
