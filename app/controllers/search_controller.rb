require 'open-uri'
require 'json'

class SearchController < ApplicationController
  
  def index
    @q         = params[:q]
    @votes     = [*Vote.search(@q)]
    @senators  = [*Senator.search(@q)]
    @mps       = [*Mp.search(@q)]
    @statements = [*HansardStatement.search(@q)]
    
    @last_vote = Vote.first :order => "vote_date DESC"
  end
  
  def postal_code
    @q        = params[:q]
    @query     = @q.gsub(/[\s_-]/, '')
    province  = find_province_by_postal_code(@query) 
    @senators = [*Senator.find_all_by_province_id(province.id)]
    @edids     = find_edids_by_postal_code(@query)
    if not @edids.empty?
      @mps    = [*Mp.find_all_by_riding_id(@edids)]
    else
      @mps    = []
    end
  end
  
  private
  
  def find_edids_by_postal_code(postal_code)
    edids = []
    url = "http://postal-code-to-edid-webservice.heroku.com/postal_codes/#{postal_code}"
    begin
      open(url) { |f|
        response = f.read
        result = JSON.parse(response)
        edids = result
      }
    rescue
    end
    return edids
  end
  
  def find_province_by_postal_code(postal_code)
    return case postal_code.upcase
      when /^A/: Province.find_by_name_en("Newfoundland and Labrador")
      when /^B/: Province.find_by_name_en("Nova Scotia")
      when /^C/: Province.find_by_name_en("Prince Edward Island")
      when /^E/: Province.find_by_name_en("New Brunswick")
      when /^G/: Province.find_by_name_en("Quebec")
      when /^H/: Province.find_by_name_en("Quebec")
      when /^J/: Province.find_by_name_en("Quebec")
      when /^K/: Province.find_by_name_en("Ontario")
      when /^L/: Province.find_by_name_en("Ontario")
      when /^M/: Province.find_by_name_en("Ontario")
      when /^N/: Province.find_by_name_en("Ontario")
      when /^P/: Province.find_by_name_en("Ontario")
      when /^R/: Province.find_by_name_en("Manitoba")
      when /^S/: Province.find_by_name_en("Saskatchewan")
      when /^T/: Province.find_by_name_en("Alberta")
      when /^V/: Province.find_by_name_en("British Columbia")
      when /^X0A/: Province.find_by_name_en("Nunavut")
      when /^X0B/: Province.find_by_name_en("Nunavut")
      when /^X0C/: Province.find_by_name_en("Nunavut")
      when /^X0E/: Province.find_by_name_en("Northwest Territories")
      when /^X0G/: Province.find_by_name_en("Northwest Territories")
      when /^X1E/: Province.find_by_name_en("Northwest Territories")
      when /^Y/: Province.find_by_name_en("Yukon")
    end
  end
  
end
