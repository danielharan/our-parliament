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
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        elsif HansardStatement === entry.object
          xml.title t("members.activity_feed.hansard_statement", :mp_name => @mp.name, :topic => entry.object.topic)
          xml.description "#{entry.object.text} (#{entry.object.time})"
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        elsif Tweet === entry.object
          xml.title t("members.activity_feed.twitter_post", :mp_name => @mp.name)
          xml.description "#{auto_link(entry.object.text)} (#{entry.object.time})"
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        end
      end
    end
  end
end