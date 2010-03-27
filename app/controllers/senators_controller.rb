class SenatorsController < ApplicationController
  def index
    @senators = Senator.all
  end
end
