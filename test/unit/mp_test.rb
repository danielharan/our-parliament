require 'test_helper'

class MpTest < ActiveSupport::TestCase
  should_have_many :recorded_votes
  
  def test_link_construction
    mp = Factory(:mp)
    mp.wikipedia        = "http://en.wikipedia.org/wiki/Alan_Tonks"
    mp.wikipedia_riding = "http://en.wikipedia.org/wiki/York_South—Weston"
    mp.twitter          = "tweeter"
    mp.facebook         = "http://www.facebook.com/pages/Alan-Tonks/6334782980"
    
    assert mp.links.is_a?(Hash)
    
    assert_equal "http://en.wikipedia.org/wiki/Alan_Tonks", mp.links["wikipedia"]
    assert_equal "http://en.wikipedia.org/wiki/York_South—Weston", mp.links["wikipedia (riding)"]
    assert_equal "http://twitter.com/tweeter", mp.links["@tweeter"]
    assert_equal "http://www.facebook.com/pages/Alan-Tonks/6334782980", mp.links["facebook"]
  end
  
  def test_link_returns_empty
    mp = Factory(:mp)
    mp.twitter = ''
    mp.wikipedia = ''
    
    assert !mp.links.keys.any?, "should not have links, but had #{mp.links.inspect}"
  end
  
  def test_news_search_name
    assert_equal "John%20Abbott%20MP",     Factory(:mp, :name => "Hon. John Abbott").news_search_name
    assert_equal "Stephen%20Harper%20MP", Factory(:mp, :name => "Right Hon. Stephen Harper").news_search_name
    assert_equal "John%20Abbott%20MP",     Factory(:mp, :name => "John Abbott").news_search_name
  end
end
