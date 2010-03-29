# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def stance(mp, vote)
    st = mp.recorded_vote_for(vote).stance
    st =~ /Abstained/ ? "#{st} for" : "Voted #{st} on"
  end
end
