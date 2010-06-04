class Committee < ActiveRecord::Base
  
  translatable_columns :name
  #has_many :members, :class_name => "CommitteeMembership", :include => "mp"
  
  def current_members
    return CommitteeMembership.find_by_sql(["SELECT m.* FROM committees c, committee_memberships m, mps mp WHERE c.id = ? AND c.id = m.committee_id AND m.mp_id = mp.id AND m.parliament = ? AND m.session = ? ORDER BY mp.name", id, ENV['CURRENT_PARLIAMENT'].to_i, ENV['CURRENT_SESSION'].to_i])
  end
  
  def current_members_by_role
    members_by_role = {}
    current_members.each { |member|
      members = members_by_role[member.committee_role_id]
      if not members
        members = []
        members_by_role[member.committee_role_id] = members
      end
      members << member
    }
    return members_by_role
  end
  
end
