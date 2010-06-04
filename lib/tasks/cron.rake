task :cron => :environment do
  if Time.now.hour == 0 # run at midnight
    Rake::Task['update:hansards'].execute
    Rake::Task['update:twitter'].execute
  end
end