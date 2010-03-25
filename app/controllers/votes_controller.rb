class VotesController < ApplicationController
  def index
    @votes = Vote.all
  end
end
