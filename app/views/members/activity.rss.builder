xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Recent activity for #{@mp.name}"
    xml.description "Activity for #{@mp.name}, MP for #{@mp.constituency_name}"
    for entry in @activity_stream.entries
      xml.item do
        if Vote === entry.object
          xml.title truncate(entry.object.context, 50)
          xml.description "#{@mp.name} #{stance(@mp, entry.object).downcase} #{truncate(entry.object.context, 70)} (#{entry.object.vote_date})"
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        elsif HansardStatement === entry.object
          xml.title "#{@mp.name} commented on #{entry.object.topic}"
          xml.description "#{entry.object.text} (#{entry.object.time})"
          xml.pubDate entry.object.created_at.to_s(:rfc822)
        end
      end
    end
  end
end