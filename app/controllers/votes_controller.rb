class VotesController < ApplicationController
  before_filter :cache_page, :only => [:index]
  before_filter :fetch_random_links, :only => [:index, :show]
  
  def index
    @votes = Vote.all
  end
  
  def show
    @vote = Vote.find_by_id(params[:id])
    @votes_by_party = @vote.total_votes_by_party
    @parties = Party.find_all_by_id(@votes_by_party.keys)
  end
  
end
