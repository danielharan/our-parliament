class DebatesController < ApplicationController
  before_filter :fetch_random_links, :only => [:index, :show]
  
  def index
    @hansards = Hansard.find_all_by_parliament_and_session(ENV['CURRENT_PARLIAMENT'].to_i, ENV['CURRENT_SESSION'].to_i, :order => "date ASC")
    @years = []
    @hansards_by_year = {}
    @hansards.each { |hansard|
      hansards_by_month = @hansards_by_year[hansard.date.year]
      if not hansards_by_month
        hansards_by_month = {}
        @hansards_by_year[hansard.date.year] = hansards_by_month
        @years << hansard.date.year
      end
      hansards_by_day = hansards_by_month[hansard.date.month]
      if not hansards_by_day
        hansards_by_day = {}
        hansards_by_month[hansard.date.month] = hansards_by_day
      end
      hansards_by_day[hansard.date.day] = hansard
    }
  end
  
  def show
    @hansard = Hansard.find_by_date(params[:id])
  end
  
end
