class Admin::MembersController < ApplicationController
  before_filter :basic_admin
  
  def index
    @mps = Mp.all.sort_by &:name
  end
  
  def update
    flash[:notice] = "twitters updated!"
    
    params[:mps].each do |mpid, attributes|
      Mp.find(mpid).update_attributes(attributes)
    end
    
    redirect_to admin_members_url
  end
end
