class CommitteesController < ApplicationController
  
  def index
    @current_committees = Committee.find_by_sql(["SELECT c.* FROM committees c, committee_memberships m WHERE c.id = m.committee_id AND m.parliament = ? AND m.session = ? GROUP BY c.id ORDER BY c.name", CURRENT_PARLIAMENT, CURRENT_SESSION])
  end

  def show
    @committee = Committee.find(params[:id])
  end

end
