require 'test_helper'

class SenatorsControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      3.times { Factory(:senator) }
      
      get :index
    end
    
    should_assign_to :senators
    should_respond_with :success
  end
  
  context "on GET to show" do
    setup do
      senator = Factory(:senator)
      
      get :show, :id => senator.id
    end
    
    should_assign_to :senator
    should_respond_with :success
  end
end
