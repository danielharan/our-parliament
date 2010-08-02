require 'hpricot'
require 'open-uri'

class Mp < ActiveRecord::Base
  index do
    parl_gc_id
    parl_gc_constituency_id
    name
    email
    website
    parliamentary_phone
    parliamentary_fax
    constituency_address
    constituency_city
    constituency_postal_code
    constituency_phone
    constituency_fax
  end 

  has_attached_file :image,
                    :styles      => { :medium => "120x120>", :small => "40x40>" },
                    :storage     => :s3,
                    :path        => ":attachment/:id/:style.:extension",
                    :bucket      => 'citizen_factory',
                    :s3_credentials => {:access_key_id => ENV["AWS_ACCESS_KEY_ID"], :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]}

  has_and_belongs_to_many :postal_codes
  has_many :recorded_votes, :include => ["vote","mp"]
  #has_many :parliamentary_functions
  has_many :current_parliamentary_functions, :class_name => "ParliamentaryFunction", :conditions => "end_date IS NULL"
  #has_many :committees, :class_name => "CommitteeMembership", :include => "committee"
  has_many :current_committees, :class_name => "CommitteeMembership", :conditions => "parliament = #{ENV['CURRENT_PARLIAMENT'].to_i} AND session = #{ENV['CURRENT_SESSION'].to_i}"
  has_many :election_results, :include => "election"
  has_many :tweets, :order => "created_at DESC"
  belongs_to :province
  belongs_to :riding, :include => "province"
  belongs_to :party
  has_and_belongs_to_many :news_articles, :join_table => 'mps_news_articles'
  
  named_scope :active, :conditions => {:active => true}
  
  def current_voting_stats
    stats = {}
    Vote.find_by_sql(:all, :conditions => ["mp_id"])
  end
  
  class << self
    def get_list
      list = open("http://webinfo.parl.gc.ca/MembersOfParliament/MainMPsCompleteList.aspx?TimePeriod=Current&Language=E")
      list.each_line do |line|
        m = line.match(/ProfileMP\.aspx\?Key=(\d+)/)
        Mp.create(:parl_gc_id => m[1]) if m && !Mp.find_by_parl_gc_id(m[1])
      end
    end
    
    def find_by_constituency_name_and_last_name(constituency_name, lastname)
      mps = find :all, :include => [:riding], :conditions => {'ridings.name_en' => constituency_name}
      # puts mps.inspect
      # puts "for lastname: #{lastname}"
      
      mps.detect {|mp| mp.name =~ /#{lastname}$/}
    end
  end
  
  def age
    now = Time.now.utc.to_date
    return date_of_birth ? now.year - date_of_birth.year - (date_of_birth.to_date.change(:year => now.year) > now ? 1 : 0) : nil
  end
  
  def first_elected_date
    return election_results.empty? ? nil : election_results.last.election.date
  end

  def recorded_vote_for(vote)
    recorded_votes.find_by_vote_id(vote.id) || recorded_votes.new
  end

  def links
    h = {}
    h[I18n.t('members.weblink.facebook', :member_name => name)]         = facebook                        unless facebook.blank?
    h[I18n.t('members.weblink.wikipedia', :member_name => name)]        = wikipedia                       unless wikipedia.blank?
    h[I18n.t('members.weblink.wikipedia_riding', :member_name => name)] = wikipedia_riding                unless wikipedia_riding.blank?
    h[I18n.t('members.weblink.twitter', :member_name => name)]          = "http://twitter.com/#{twitter}" unless twitter.blank?
    h[I18n.t('members.weblink.personal', :member_name => name)]         = website                         unless website.blank?
    h
  end

  def news_search_name
    URI.encode(name.gsub(/^.*Hon. /, '').gsub(',', '') + " MP")
  end

  def download
    `curl \"http://webinfo.parl.gc.ca/MembersOfParliament/ProfileMP.aspx?Key=#{parl_gc_id}&Language=E\" > tmp/mps/mp_#{parl_gc_id}`
  end
  
  def downloaded?
    File.exists?("tmp/mps/mp_#{parl_gc_id}")
  end

  def extract_summary_info
    doc = Hpricot(File.read("tmp/mps/mp_#{parl_gc_id}"))
    self.parl_gc_constituency_id = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_TombstoneContent_TombstoneContent_ucHeaderMP_hlConstituencyProfile"]')[0].attributes['href'].match(/Key=(\d+)/)[1]
    self.constituency_name = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_TombstoneContent_TombstoneContent_ucHeaderMP_hlConstituencyProfile"]').innerHTML
    self.party = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_TombstoneContent_TombstoneContent_ucHeaderMP_hlCaucusWebSite"]').innerHTML
    self.name = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_TombstoneContent_TombstoneContent_ucHeaderMP_lblMPNameData"]').innerHTML
    self.email = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_DetailsContent_DetailsContent__ctl0_hlEMail"]').innerHTML
    website = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_DetailsContent_DetailsContent__ctl0_hlWebSite"]')
    self.website = website[0].attributes['href'] if website[0]
    self.parliamentary_phone = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_DetailsContent_DetailsContent__ctl0_lblTelephoneData"]').innerHTML
    self.parliamentary_fax = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_DetailsContent_DetailsContent__ctl0_lblFaxData"]').innerHTML
    self.preferred_language = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_DetailsContent_DetailsContent__ctl0_lblPrefLanguageData"]').innerHTML

    const_info = doc.search('//*[@id="MasterPage_MasterPage_BodyContent_PageContent_Content_DetailsContent_DetailsContent__ctl0_divConstituencyOffices"]/table/tr/td')
    self.constituency_address = const_info[0].innerHTML.gsub(/, *$/, '')
    self.constituency_city, self.constituency_province = const_info[1].innerHTML.split(', ')
    self.constituency_postal_code = const_info[2].innerHTML
    self.constituency_phone = const_info[4].innerHTML.gsub(/Telephone: /, '')
    self.constituency_fax = const_info[5].innerHTML.gsub(/Fax: /, '')

    self.save
  end
  
  def scrape_edid
    constituency_profile = open("http://webinfo.parl.gc.ca/MembersOfParliament/ProfileConstituency.aspx?Key=#{parl_gc_constituency_id}&Language=E").read
    self.update_attribute(:ed_id,constituency_profile.match(/ED=(\d+)/)[1])
  end
  
  def hansard_statements
    HansardStatement.find_by_sql(["SELECT * FROM hansard_statements WHERE member_name = ? ORDER BY time DESC;", name])
  end
  
  def fetch_new_tweets
    tweets = []
    url = "http://search.twitter.com/search.json?q=from:#{twitter}"
    begin
      open(url) { |f|
        JSON.parse(f.read)['results'].each { |result|
          if not Tweet.find_by_twitter_id(result['id'])
            tweet = Tweet.create({
              :mp_id => id,
              :text => result['text'],
              :created_at => result['created_at'],
              :twitter_id => result['id']
            })
            tweets << tweet
          end
        }
      }
    rescue
    end
    return tweets
  end
  
  def fetch_news_articles
    articles = []
    articles = GoogleNews.search(name + ' AND ("MP" OR "Member of Parliament") location:Canada')
    return articles
  end
end