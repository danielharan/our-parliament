class Vote < ActiveRecord::Base
  has_many :recorded_votes, :include => "mp"
  
  index do
    bill_number 'A' # high priority
    title
    context
    sponsor
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
  
end
