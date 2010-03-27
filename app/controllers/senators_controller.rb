class SenatorsController < ApplicationController
  def index
    @senators = Senator.all
  end
  
  def show
    @senator = Senator.find params[:id]
  end
end
