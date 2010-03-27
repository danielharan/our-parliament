require 'httparty'
class VoteList

  include HTTParty
  format :xml
  
  def self.uri(parliament, session)
     "http://www2.parl.gc.ca/HouseChamberBusiness/Chambervotelist.aspx?Language=E&Mode=1&Parl=#{parliament}&Ses=#{session}&FltrParl=#{parliament}&FltrSes=#{session}&VoteType=0&AgreedTo=True&Negatived=True&Tie=True&Page=1&xml=True&SchemaVersion=1.0"
  end
  
  def self.fetch(parliament, session)
    doc = get(uri(parliament, session), :headers => {"User-Agent" => "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"})

    vote_hashes = doc["Votes"]['Vote'].is_a?(Array) ? doc["Votes"]['Vote'] : [doc["Votes"]['Vote']]
    vote_hashes.collect do |node|
      build_vote node
    end
  end
  
  def self.build_vote(node)
    # >> node["Votes"]["Vote"].first.keys
    # => ["parliament", "sitting", "number", "TotalYeas", "date", "session", "Decision", "TotalNays", "TotalPaired", "Description"]
    puts node.inspect

    Vote.new :title     =>  node["Description"],
             :passed    => (node["Decision"] == "Agreed to"),
             :in_favour =>  node["TotalYeas"],
             :opposed   =>  node["TotalNays"],
             :paired    =>  node["TotalPaired"],
             :context   =>  node["Description"],
             :parliament => node["parliament"],
             :session    => node["session"],
             :number     => node["number"]
  end
end
