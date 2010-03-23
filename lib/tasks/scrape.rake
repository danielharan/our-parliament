def between(min, max)
  min + rand((max - min) * 1_000) / 1_000
end

namespace :scrape do
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
  
  desc "get voting records for a specific vote"
  task :vote => :environment do
    Vote.transaction do
      parliament = ENV["PARLIAMENT"] || Vote.maximum(:parliament)
      session    = ENV["SESSION"]    || Vote.maximum(:session, :conditions => {:parliament => parliament })
      number     = ENV["NUMBER"]     || Vote.maximum(:number,  :conditions => {:parliament => parliament, :session => session }) + 1

      voting_record = Confidence::Vote.fetch :parliament => parliament, :session => session, :number => number

      vote = Vote.create :parliament => parliament, :session => session, :number => number,
                         :sponsor => voting_record.sponsor, :bill_number => voting_record.bill.number,
                         :title => voting_record.bill.title, :context => voting_record.context

      voting_record.participants.each do |member|
        # FIXME: HACK! we don't have parliament and session yet, although it's not really an edge case
        #mp = Mp.find_by_parliament_and_session_and_constituency_name(parliament, session, member.constituency)
        mp = Mp.find_by_constituency_name(member.constituency)
      
        mp.recorded_votes.create :vote => vote, :stance => member.recorded_vote
      end
      # TODO - update summary information for vote, in_favour: nil, opposed: nil, paired: nil, passed: nil
    end
  end
end