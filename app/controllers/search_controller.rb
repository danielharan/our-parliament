class SearchController < ApplicationController
  def index
    @q        = params[:q]
    @votes    = [*Vote.search(@q)]
    @senators = [*Senator.search(@q)]
    @mps      = [*Mp.search(@q)]
    
    @last_vote = Vote.first :order => "vote_date DESC"
  end
end
