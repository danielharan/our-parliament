require 'open-uri'
require 'json'

class SearchController < ApplicationController
  before_filter :cache_page, :only => [:index]
  
  def index
    @q        = params[:q]
    @votes    = [*Vote.search(@q)]
    @senators = [*Senator.search(@q)]
    @mps      = [*Mp.search(@q)]
    
    @last_vote = Vote.first :order => "vote_date DESC"
  end
  
  def postal_code
    @q        = params[:q]
    edids     = find_edids_by_postal_code(@q)
    province  = find_province_by_postal_code(@q) 
    @senators = [*Senator.find_all_by_province(province)]
    @mps      = [*Mp.find_by_ed_id(edids)]
  end
  
  private
  
  def find_edids_by_postal_code(postal_code)
    edids = []
    url = "http://postal-code-to-edid-webservice.heroku.com/postal_codes/#{postal_code}"
    result = JSON.parse(open(url).read)
    edids << result["edid"]
    return edids
  end
  
  def find_province_by_postal_code(postal_code)
    return case postal_code.upcase
      when /^A/: "Newfoundland & Labrador"
      when /^B/: "Nova Scotia"
      when /^C/: "Prince Edward Island"
      when /^E/: "New Brunswick"
      when /^G/: "Quebec"
      when /^H/: "Quebec"
      when /^J/: "Quebec"
      when /^K/: "Ontario"
      when /^L/: "Ontario"
      when /^M/: "Ontario"
      when /^N/: "Ontario"
      when /^P/: "Ontario"
      when /^R/: "Manitoba"
      when /^S/: "Saskatchewan"
      when /^T/: "Alberta"
      when /^V/: "British Columbia"
      when /^X0A/: "Nunavut"
      when /^X0B/: "Nunavut"
      when /^X0C/: "Nunavut"
      when /^X0E/: "Northwest Territories"
      when /^X0G/: "Northwest Territories"
      when /^X1E/: "Northwest Territories"
      when /^Y/: "Yukon"
    end
  end
  
end
