require 'test_helper'

class Admin::SenatorsControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      Admin::SenatorsController.any_instance.stubs(:basic_admin).returns(true)
      3.times { Factory(:senator) }
      
      get :index
    end
    
    should_assign_to :senators
    should_respond_with :success
  end
end
