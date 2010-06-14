require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  context "searching from the home page" do
    setup do
      v  = Factory(:vote, :title => "important bill")
      mp = Factory(:mp, :name => "Important person")
      mp = Factory(:mp, :name => 'nobody')
      s  = Factory(:senator, :name => "Hon. Important Person")
      
      Vote.expects(:search).returns([v])
      Mp.expects(:search).returns([mp])
      Senator.expects(:search).returns([s])
      
      get :index, :q => "important"
    end
    
    should_assign_to :mps, :votes, :senators, :q
    should_respond_with :success
  end
end
