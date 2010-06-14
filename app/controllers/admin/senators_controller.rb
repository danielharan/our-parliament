class Admin::SenatorsController < ApplicationController
  before_filter :basic_admin
  
  def index
    @senators = Senator.all.sort_by &:name
  end
  
  def update
    flash[:notice] = "senator information updated!"
    
    params[:senators].each do |senator_id, attributes|
      Senator.find(senator_id).update_attributes(attributes)
    end
    
    redirect_to admin_senators_url
  end
end
