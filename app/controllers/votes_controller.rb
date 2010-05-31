class VotesController < ApplicationController
  before_filter :cache_page, :only => [:index]
  
  def index
    @votes = Vote.all
  end
  
  def show
    @vote = Vote.find_by_id(params[:id])
  end
  
end
