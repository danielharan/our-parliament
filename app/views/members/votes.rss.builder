xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Recent votes by #{@mp.name}"
    xml.description "Votes by #{@mp.name}, MP for #{@mp.constituency_name}"
   # xml.link formatted_member_url(@mp, :rss)
    
    for vote in @votes
      xml.item do
        xml.title vote.context
        xml.description "#{@mp.name} #{stance(@mp, vote).downcase} #{truncate(vote.context, 70)} (#{vote.vote_date})"
        xml.pubDate vote.created_at.to_s(:rfc822)
        # xml.link formatted_article_url(article, :rss)
        # xml.guid formatted_article_url(article, :rss)
      end
    end
  end
end