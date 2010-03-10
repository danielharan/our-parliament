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
end