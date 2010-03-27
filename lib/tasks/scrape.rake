def between(min, max)
  min + rand((max - min) * 1_000) / 1_000
end

def scrape_vote(parliament, session, number)
  vote = Vote.find_by_parliament_and_session_and_number parliament, session, number

  if vote.recorded_votes.count > 1
    puts "already fetched votes"
    return
  end

  voting_record = Confidence::Vote.fetch :parliament => parliament, :session => session, :number => number

  Vote.transaction do
    voting_record.participants.each do |member|
      # FIXME: HACK! we don't have parliament and session yet, although it's not really an edge case
      #mp = Mp.find_by_parliament_and_session_and_constituency_name(parliament, session, member.constituency)
      mp = Mp.find_by_constituency_name_and_last_name(member.constituency, member.lastname)
  
      mp.recorded_votes.create :vote => vote, :stance => member.recorded_vote
    end
  end
end

namespace :scrape do
  desc "retrieve senator list"
  task :senators => :environment do
    senators = Senator.scrape_list
    
    senators.each do |senator|
      senator.save! unless Senator.find_by_name(senator.name)
    end
  end
  
  
  desc "retrieve mp list"
  task :mp_list => :environment do
    Mp.get_list
  end
  
  desc "download all mp data"
  task :spider => :environment do
    (Mp.find :all).each do |mp|
      if ! mp.downloaded?
        mp.download
        puts "downloaded: " + mp.parl_gc_id.to_s
        sleep between(10,20)
      end
    end
  end
  
  desc "extract all downloaded mp data"
  task :extract => :spider do
    (Mp.find :all).each do |mp|
      mp.extract_summary_info
      
      # YUCK: I'd like separate spidering and extraction tasks, but ed_id was tedious
      # since this runs so rarely, I'm leaving it as is
      if mp.ed_id.nil?
        mp.scrape_edid
        puts "resolved ED: #{mp.ed_id}"
        sleep between(2,5)
      end
    end
  end
  
  desc "get votes list"
  task :vote_list => :environment do
    parliament = ENV["PARLIAMENT"] || Vote.maximum(:parliament)
    session    = ENV["SESSION"]    || Vote.maximum(:session, :conditions => {:parliament => parliament })

    votes = VoteList.fetch parliament, session
    
    votes.each do |vote|
      if Vote.find_by_parliament_and_session_and_number vote.parliament, vote.session, vote.number
        puts "already found #{vote.inspect}"
      else
        puts "saving new vote: #{vote.inspect}"
        vote.save!
      end
    end
  end
  
  desc "get voting records for a specific vote"
  task :vote => :environment do
    parliament = ENV["PARLIAMENT"] || Vote.maximum(:parliament)
    session    = ENV["SESSION"]    || Vote.maximum(:session, :conditions => {:parliament => parliament })
    number     = ENV["NUMBER"]     || Vote.maximum(:number,  :conditions => {:parliament => parliament, :session => session }) + 1

    scrape_vote parliament, session, number
  end
  
  desc "get vote details for all outstanding votes in the latest parliament"
  task :all_vote_details => :environment do
    parliament = ENV["PARLIAMENT"] || Vote.maximum(:parliament)
    puts "scraping votes for parliament ##{parliament}"
    
    Vote.all(:conditions => {:parliament => parliament}).each do |vote|
      puts "session #{vote.session}, ##{vote.number}"
      if vote.recorded_votes.count > 1
        puts "   -- already recorded"
      else
        puts "   -- fetching"
        scrape_vote parliament, vote.session, vote.number
        sleep between(1, 3)
      end
    end
  end
end