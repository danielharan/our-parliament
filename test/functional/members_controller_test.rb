require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      v = Factory(:vote)
      3.times do
        mp = Factory(:mp)
        mp.recorded_votes.create :vote => v, :stance => 'nay'
      end
      
      get :index
    end
    
    should_assign_to :mps, :last_vote
    should_respond_with :success
  end
  
  context "on GET to show" do
    setup do
      mp = Factory(:mp)
      
      get :show, :id => mp.id
    end
    
    should_assign_to :votes
    should_respond_with :success
  end

  
  context "on GET to edit without auth" do
    setup do
      mp = Factory(:mp)
      
      get :edit, :id => mp.id
    end
    
    should_respond_with 401
  end

  context "on GET to edit with auth" do
    setup do
      MembersController.any_instance.stubs(:basic_admin).returns(true)
      mp = Factory(:mp)
      
      get :edit, :id => mp.id
    end
    
    should_respond_with :success
  end
  
  context "on PUT to update" do
    setup do
      MembersController.any_instance.stubs(:basic_admin).returns(true)
      @mp = Factory(:mp, :name => "before")
      
      put :update, :id => @mp.id, :mp => {:name => "after"}
    end
    
    should_respond_with :redirect
    
    should "have updated the mp's name" do
      assert_equal "after", @mp.reload.name
    end
  end
  
  context "on GET to votes" do
    setup do
      @mp = Factory(:mp)
      
      get :votes, :id => @mp.id
    end
    
    should_assign_to :mp, :votes
    should_respond_with :success
    should_respond_with_content_type 'application/rss+xml'
  end
end
