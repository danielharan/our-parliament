class SenatorsController < ApplicationController
  def index
    @senators = Senator.all
  end
  
  def show
    fetch_random_links
    @senator = Senator.find params[:id]
  end
end
