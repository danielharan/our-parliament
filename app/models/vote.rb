class Vote < ActiveRecord::Base
  has_many :recorded_votes, :include => "mp"
  
  index do
    bill_number 'A' # high priority
    title
    context
    sponsor
  end
  
  def title
    index = find_language_split(super)
    if I18n.locale == "fr"
      return index ? super[index+1..-1] : super
    else
      return index ? super[0..index] : super
    end
  end
  
  def self.last(n)
    find(:all, :order => "vote_date DESC", :limit => n)
  end
  
  def total_votes
    in_favour + opposed + paired
  end
  
  def total_votes_by_party
    votes_by_party = {}
    recorded_votes.each { |vote|
      if vote.mp.party_id
        votes_by_stance = votes_by_party[vote.mp.party_id]
        if not votes_by_stance
          votes_by_stance = {'yea' => 0, 'nay' => 0, 'paired' => 0, 'votes' => []}
          votes_by_party[vote.mp.party.id] = votes_by_stance
        end
        votes_by_stance[vote.stance] = votes_by_stance[vote.stance] + 1
        votes_by_stance['votes'] << vote
      end
    }
    return votes_by_party 
  end
  
  private 
  
  def find_language_split(text)
    start_index = text.length / 3
    return text.index(/[a-z][A-Z,\d]/, start_index) || 
           text.index(/\)[A-Z,\d]/, start_index) || 
           text.index(/\d[A-Z]/, start_index) || 
           text.index(/\d{2}e/, start_index)
  end
  
end
