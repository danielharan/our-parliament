# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale, :set_title
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password
  
  private
  
    def set_locale
      if request.host =~ /.*fabriquecitoyenne\..*/
        I18n.locale = "fr"
      elsif params[:locale]
        I18n.locale = params[:locale]
      elsif request.env['HTTP_ACCEPT_LANGUAGE']
        I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      end
    end
    
    def set_title
      @title = I18n.t("#{params[:controller]}.#{params[:action]}.title")
    end
  
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
