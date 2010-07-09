namespace :update do
  desc "update the list of hansard statements from the Open Parliament API"
  task :hansards => :environment do
    puts "Updating hansard statements..."
    num_found = 0
    Hansard.get_list.each { |hansard_list_info|
      if not Hansard.find_by_id(hansard_info['id'])       
        hansard_info = Hansard.fetch(hansard_list_info['id'])
        if hansard_info
          hansard = {
            :date => hansard_info['date'],
            :parliament => hansard_info['parliament'],
            :session => hansard_info['session'],
            :num => hansard_list_info['number'],
            :url => hansard_info['original_url']
          }
          hansard_info['statements'].each { |statement_info|
            statement = {
              :hansard_id => hansard_info['id'],
              :time => statement_info['time'],
              :attribution => statement_info['attribution'],
              :heading => statement_info['heading'],
              :topic => statement_info['topic'],
              :text => statement_info['text'],
            }
            if statement_info['politician']
              statement[:member_name] = statement_info['politician']['name']
              statement[:member_id] = statement_info['politician']['member_id']
            end
            HansardStatement.new(statement).save
          }
          h = Hansard.new(hansard)
          h.id = hansard_info['id']
          h.save
          num_found = num_found + 1
        end
      end
    }
    puts "Found #{num_found} new hansards" if num_found > 0
  end
  
  desc "update the list of tweet by MPs using the Twitter Search API"
  task :twitter => :environment do
    puts "Updating twitter feeds..."
    Mp.find(:all, :conditions => "twitter IS NOT NULL AND LENGTH(twitter) > 0").each { |mp|
      tweets = mp.fetch_new_tweets
      puts "Found #{tweets.size} new tweets for #{mp.name}" if tweets.size > 0
      sleep(1)
    }
  end
  
  desc "update the list of news articles for MPs ad Senators using the Google News"
  task :news => :environment do
    puts "Updating news feeds..."
    Mp.find(:all).each { |mp|
      articles = mp.fetch_news_articles
      puts "Found #{articles.size} new articles for #{mp.name}" if articles.size > 0
      sleep(1)
    }
    Senator.find(:all).each { |senator|
      articles = senator.fetch_news_articles
      puts "Found #{articles.size} new articles for #{senator.name}" if articles.size > 0
      sleep(1)
    }
  end
  
end