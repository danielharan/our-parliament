class SenatorsController < ApplicationController
  before_filter :basic_admin, :only => [:edit, :update]
  before_filter :find_senator, :except => [:index]
  
  def index
    @senators = Senator.all
  end
  
  def show
    fetch_random_links
  end
  
  def edit
  end
  
  def update
    @senator.update_attributes params[:senator]
    
    redirect_to senator_path(@senator)
  end
  
  private
    def find_senator
      @senator = Senator.find params[:id]
    end
end
