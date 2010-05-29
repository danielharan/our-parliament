class CommitteesController < ApplicationController
  
  def index
    @current_committees = Committee.find_by_sql(["SELECT c.* FROM committees c, committee_memberships m WHERE c.id = m.committee_id AND m.parliament = ? AND m.session = ? GROUP BY c.id, c.name ORDER BY c.name", ENV['CURRENT_PARLIAMENT'].to_i, ENV['CURRENT_SESSION'].to_i])
  end

  def show
    @committee = Committee.find(params[:id])
  end

end
