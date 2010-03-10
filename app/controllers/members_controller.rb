class MembersController < ApplicationController
  
  def index
    @mps = Mp.find(:all)
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
