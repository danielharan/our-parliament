require 'cgi'
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'hpricot'
require 'json'

class GoogleNews
  
  def self.search(query)
    articles = []
    feed_url = 'http://news.google.ca/news?pz=1&cf=all&ned=ca&hl=en&as_maxm=3&as_qdr=a&as_drrb=q&as_mind=25&as_minm=2&cf=all&as_maxd=27&scoring=n&output=rss&q=' + CGI::escape(query)
    content = ""
    open(feed_url) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)
    if rss
      rss.items.each do |item|
        title_parts = item.title.split('-')
        source_name = title_parts.pop
        summary = ''
        if item.description
          doc = Hpricot(item.description)
        summary = doc.search("font[@size='-1']")[1].inner_text
        end
        article_data = {
          :url => item.link.split('&url=')[1].strip,
          :summary => summary.strip,
          :title => title_parts.join('-').strip,
          :date => item.date.to_s,
          :source => source_name.strip
        }
  
        article = NewsArticle.find_by_url(article_data[:url])
        if not article and article_data[:url].length < 1024 and article_data[:title].length < 1024 and article_data[:summary].length < 1024
           article = NewsArticle.new(article_data)
           article.save
        end
        articles << article if article
      end
    else
      puts "Unable to parse feed: " + feed_url
    end
    return articles
  end
  
end