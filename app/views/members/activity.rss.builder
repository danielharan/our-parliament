xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t("members.activity_feed.title", :mp_name => @mp.name)
    xml.description t("members.activity_feed.description", :mp_name => @mp.name, :riding_name => @mp.riding.name)
    for entry in @activity_stream.entries
      xml.item do
        if Vote === entry.object
          xml.title truncate(entry.object.context, 50)
          xml.description t("members.activity_stream.vote.#{@mp.recorded_vote_for(entry.object).stance.underscore}") + " #{truncate(entry.object.context, 70)} (#{entry.object.vote_date})"
          xml.link url_for(:controller => :votes, :action => :show, :id => entry.object.id)
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        elsif HansardStatement === entry.object
          xml.title t("members.activity_feed.hansard_statement", :mp_name => @mp.name, :topic => entry.object.topic)
          xml.description "#{entry.object.text} (#{entry.object.time})"
          xml.link url_for(:controller => :debates, :action => :show, :id => entry.object.hansard.date, :anchor => entry.object.id)
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        elsif Tweet === entry.object
          xml.title t("members.activity_feed.twitter_post", :mp_name => @mp.name)
          xml.description "#{auto_link(entry.object.text)} (#{entry.object.time})"
          xml.link "http://twitter.com/#{@mp.twitter}/status/#{entry.object.twitter_id}"
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        elsif NewsArticle === entry.object
          xml.title t("members.activity_feed.news_article", :mp_name => @mp.name, :article_name => entry.object.title)
          xml.description entry.object.summary
          xml.link entry.object.url
          xml.pubDate entry.object.date.to_s(:rfc822)
        end
      end
    end
  end
end