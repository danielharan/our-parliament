# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password
  
  private
     def basic_admin
        authenticate_or_request_with_http_basic do |id, password| 
            id == ENV["ADMIN_USER"] && password == ENV["ADMIN_PASSWORD"]
        end
     end
end
