class MembersController < ApplicationController
  
  def index
    @mps = Mp.find(:all)
  end
  
  def show
    @mp = Mp.find(params[:id])
  end
end
