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
     
     def fetch_random_links
       @article_links  = Link.article.all.sort_by(&:rand)[0,3]  # TODO: nix the .all
       @glossary_links = Link.glossary.all.sort_by(&:rand)[0,5]
   end
   
   def cache_page
     response.headers['Cache-Control'] = 'public, max-age=300'
 end
 
end
