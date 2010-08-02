task :cron => :environment do
  if Time.now.hour == 0 # run at midnight
    Rake::Task['update:hansards'].execute
    Rake::Task['scrape:vote_list'].execute
    Rake::Task['scrape:all_vote_details'].execute
  end
  Rake::Task['update:twitter'].execute
  Rake::Task['update:news'].execute
end