class VotesController < ApplicationController
  before_filter :cache_page, :only => [:index]
  
  def index
    @votes = Vote.all
  end
end
