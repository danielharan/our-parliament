class Committee < ActiveRecord::Base
  
  #translations :name
  #has_many :members, :class_name => "CommitteeMembership", :include => "mp"
  
  def current_members
    return CommitteeMembership.find_by_sql(["SELECT m.* FROM committees c, committee_memberships m, mps mp WHERE c.id = ? AND c.id = m.committee_id AND m.mp_id = mp.id AND m.parliament = ? AND m.session = ? GROUP BY m.mp_id, mp.name ORDER BY mp.name", id, ENV['CURRENT_PARLIAMENT'].to_i, ENV['CURRENT_SESSION'].to_i])
  end
  
end
