require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      3.times { Factory(:mp) }
      
      get :index
    end
    
    should_respond_with :success
  end
  
  context "on GET to show" do
    setup do
      mp = Factory(:mp)
      
      get :show, :id => mp.id
    end
    
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
end
