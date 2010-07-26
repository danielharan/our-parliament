require 'open-uri'
require 'hpricot'

USER_AGENT = "Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.4) Gecko/20100513 Firefox/3.6.4"

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
  
  scrape_legisinfo(vote)
end

def scrape_legisinfo(vote)
  voting_record = Confidence::Vote.fetch :parliament => vote.parliament, :session => vote.session, :number => vote.number
  vote.bill_number = voting_record.bill ? voting_record.bill.number : nil
  if vote.bill_number
    feed_url = "http://www2.parl.gc.ca/Sites/LOP/LEGISINFO/RSSFeeds.asp?parlNumber=#{vote.parliament}&session=#{vote.session}&chamber=C&billNumber=#{vote.bill_number[2..-1]}&billLetter=&language=E"
    open(feed_url) { |src|
      content = src.read
      id_pattern = Regexp.new('http://www2\.parl\.gc\.ca/Sites/LOP/LEGISINFO/index\.asp\?Language=E&amp;query=(\d+)&amp;Session=\d+&amp;List=toc', Regexp::IGNORECASE | Regexp::MULTILINE)
      id_matches = id_pattern.match(content)
      if id_matches != nil
        vote.legisinfo_bill_id = id_matches[1].to_i
      end
    }
  end
  vote.save
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
      if Vote.find_by_parliament_and_session_and_number(vote.parliament, vote.session, vote.number)
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
  
  desc "update legisinfo ids for all votes"
  task :legisinfo_vote => :environment do
    parliament = ENV["PARLIAMENT"] || Vote.maximum(:parliament)
    session    = ENV["SESSION"]    || Vote.maximum(:session, :conditions => {:parliament => parliament })
    #Vote.find_all_by_parliament_and_session(parliament, session).each { |vote|
    Vote.all.each { |vote|
       scrape_legisinfo(vote)
    }
  end
  
  desc "update committee acronyms"
  task :committee_acronyms => :environment do
    parliament = ENV["PARLIAMENT"] || Vote.maximum(:parliament)
    session    = ENV["SESSION"]    || Vote.maximum(:session, :conditions => {:parliament => parliament })
    url = "http://www2.parl.gc.ca/CommitteeBusiness/CommitteeList.aspx?Language=E&Mode=1&Parl=#{parliament}&Ses=#{session}"
    open(url, "User-Agent" => USER_AGENT) { |src|
      content = src.read
      doc = Hpricot(content)
      doc.search("ul.CommitteeListItem li.CommitteeItem").each { |committee_list|
        committee_name = committee_list.at("span.CommitteeItemText a").inner_text.strip
        if committee_name =~ /^(.+)\(([A-Z,\d]+)\)$/
          committee_name = $1.strip
          acronym = $2
          if committee_name == "Liaison"
            full_committee_name = "Liaison Committee"
          elsif committee_name =~ /^Bill.+/
            full_committee_name = "Legislative Committee on " + committee_name
          else
            full_committee_name = "Standing Committee on " + committee_name
          end
          committee = Committee.find_by_name_en(full_committee_name)
          if not committee
            committee = Committee.find_by_name_en("Standing Committee on the " + committee_name)
          end
          if committee
            committee.acronym = acronym
            committee.save
          else
            puts "Couldn't find " + full_committee_name
          end
        end
        if committee
          committee_list.search("ul.SubcommitteeListItem").each { |subcommittee_list|
            subcommittee_name = subcommittee_list.at("span.SubCommitteeItemText a").inner_text.strip
            if subcommittee_name =~ /^(.+)\(([A-Z,\d]+)\)$/
              subcommittee_name = $1.strip
              acronym = $2
              full_subcommittee_name = subcommittee_name + " of the " + full_committee_name
              subcommittee = Committee.find_by_name_en(full_subcommittee_name)
              if subcommittee
                subcommittee.subcommittee_of = committee.id
                subcommittee.acronym = acronym
                subcommittee.save
              end
            end
          }
        end
      }
    }
  end
end