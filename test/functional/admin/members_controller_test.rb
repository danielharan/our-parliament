require 'test_helper'

class Admin::MembersControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      Admin::MembersController.any_instance.stubs(:basic_admin).returns(true)
      3.times { Factory(:mp) }
      
      get :index
    end
    
    should_respond_with :success
  end
end
