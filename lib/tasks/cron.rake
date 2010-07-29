task :cron => :environment do
  if Time.now.hour == 0 # run at midnight
    if Date.today.wday == 0
      Rake::Task['scrape:senators'].execute
      Rake::Task['scrape:mp_list'].execute
      Rake::Task['scrape:spider'].execute
      Rake::Task['scrape:extract'].execute
    end
    Rake::Task['scrape:vote_list'].execute
    Rake::Task['scrape:all_vote_details'].execute
    Rake::Task['update:hansards'].execute
  end
  Rake::Task['update:twitter'].execute
  Rake::Task['update:news'].execute
end