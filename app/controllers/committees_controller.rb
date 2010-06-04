class CommitteesController < ApplicationController

  before_filter :fetch_random_links, :only => [:index, :show]
  
  def index
    @current_committees = Committee.find_by_sql(["SELECT c.* FROM committees c, committee_memberships m WHERE c.id = m.committee_id AND m.parliament = ? AND m.session = ? GROUP BY c.id, c.name_#{I18n.locale} ORDER BY c.name_#{I18n.locale}", ENV['CURRENT_PARLIAMENT'].to_i, ENV['CURRENT_SESSION'].to_i])
  end

  def show
    @committee = Committee.find(params[:id])
    @members_by_role = @committee.current_members_by_role
    @roles = CommitteeRole.find_all_by_id(@members_by_role.keys)
  end

end
