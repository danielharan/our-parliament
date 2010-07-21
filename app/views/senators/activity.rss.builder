xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t("senators.activity_feed.title", :senator_name => @senator.name)
    xml.description t("senators.activity_feed.description", :senator_name => @senator.name, :province_name => @senator.province.name)
    for entry in @activity_stream.entries
      xml.item do
        if Tweet === entry.object
          xml.title t("senators.activity_feed.twitter_post", :senator_name => @senator.name)
          xml.description "#{auto_link(entry.object.text)} (#{entry.object.time})"
          xml.link "http://twitter.com/#{@senator.twitter}/status/#{entry.object.twitter_id}"
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        elsif NewsArticle === entry.object
          xml.title t("senators.activity_feed.news_article", :senator_name => @senator.name, :article_name => entry.object.title)
          xml.description entry.object.summary
          xml.link entry.object.url
          xml.pubDate entry.object.date.to_s(:rfc822)
        end
      end
    end
  end
end