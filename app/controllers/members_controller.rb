class MembersController < ApplicationController
  
  def index
    @mps = Mp.find(:all)
  end
end
