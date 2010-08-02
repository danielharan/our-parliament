class CommitteesController < ApplicationController

  before_filter :fetch_random_links, :only => [:index, :show]
  
  def index
    @current_committees = Committee.find_by_sql(["SELECT DISTINCT c.* FROM committees c, committee_memberships m WHERE c.id = m.committee_id AND m.parliament = ? AND m.session = ? AND c.subcommittee_of IS NULL ORDER BY c.name_#{I18n.locale}", ENV['CURRENT_PARLIAMENT'].to_i, ENV['CURRENT_SESSION'].to_i])
  end

  def show
    @committee = Committee.find(params[:id])
    @members_by_role = @committee.current_members_by_role
    @roles = CommitteeRole.find_all_by_id(@members_by_role.keys)
    role_ranks = {
      "Chair" => 1,
      "Co-Chair" => 2,
      "Vice-Chair" => 3
    }
    @roles.sort! { |a,b|
      (role_ranks[a.name_en] ? role_ranks[a.name_en] : 999) <=> (role_ranks[b.name_en] ? role_ranks[b.name_en] : 999)
    }
  end

end
