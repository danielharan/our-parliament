require 'open-uri'
class Senator < ActiveRecord::Base
  
  def news_search_name
    URI.encode(normalized_name.gsub(/^.*Hon. /, '').gsub(',', ''))
  end
  
  def normalized_name
    last,first = name.split(',').collect(&:strip)
    [first, last].join(" ")
  end
  
  class << self
    def spider_list
      # TODO: caching logic should be extracted into scraping tools
      fname = 'tmp/spidering/senator_list'
      if File.exists?(fname)
        IO.read(fname)
      else
        returning(open("http://www.parl.gc.ca/common/senmemb/senate/isenator.asp?Language=E").read) do |content|
          File.open(fname, "w") {|f| f.puts content}
        end
      end
    end
    
    def scrape_list
      rows = Nokogiri::HTML(spider_list) / "//html/body/table[3]/tr/td[2]/table/tr"
      
      rows.reject do |row|
        row.to_s !~ /isenator/
      end.collect do |row|
        scrape_senator row
      end
    end
    
    def scrape_senator(elem)
      new :name            => clean(elem / (elem.path + "/td[1]/a")),
          :affiliation     => clean(elem / (elem.path + "/td[2]")),
          :province        => clean(elem / (elem.path + "/td[3]")),
          :nomination_date => clean(elem / (elem.path + "/td[4]")),
          :retirement_date => clean(elem / (elem.path + "/td[5]")),
          :appointed_by    => clean(elem / (elem.path + "/td[6]"))
    end
    
    private
    def clean(e)
      #gsub(/\302\240/, ' ') is a non-printed char that Nokogiri lets through
      e.first.inner_html.gsub(/&nbsp;/, ' ').gsub(/\302\240/, ' ').gsub(/\s+/, ' ').strip
    end
  end
end
