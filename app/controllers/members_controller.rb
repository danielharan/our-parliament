class MembersController < ApplicationController
  before_filter :basic_admin, :only => [:edit, :update]
  
  def index
    @mps = Mp.active.all
  end
  
  def show
    @mp = Mp.find(params[:id])
  end
  
  def edit
    @mp = Mp.find(params[:id])
  end
  
  def update
    @mp =  Mp.find(params[:id])
    @mp.update_attributes params[:mp]
    
    redirect_to member_path(@mp)
  end
end
