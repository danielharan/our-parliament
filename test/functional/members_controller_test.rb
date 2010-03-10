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
end
