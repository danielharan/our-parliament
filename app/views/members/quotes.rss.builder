xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Recent quotes by #{@mp.name}"
    xml.description "Quotes by #{@mp.name}, MP for #{@mp.constituency_name}"
   # xml.link formatted_member_url(@mp, :rss)
    
    for quote in @quotes
      xml.item do
        xml.title "#{@mp.name} commented on #{quote.topic}"
        xml.description "<strong>#{@mp.name}</strong> commented on <strong>#{quote.topic}</strong><p>#{truncate(quote.text, 200)}</p> (#{quote.time})"
        xml.pubDate quote.created_at.to_s(:rfc822)
        # xml.link formatted_article_url(article, :rss)
        # xml.guid formatted_article_url(article, :rss)
      end
    end
  end
end