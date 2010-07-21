class CreateNewsArticles < ActiveRecord::Migration
  def self.up
    create_table :news_articles do |t|
      t.string   :url, :limit => 1024
      t.string   :title, :limit => 1024
      t.string   :source
      t.timestamp :date
      t.text   :summary, :limit => 1024
    end
    create_table :mps_news_articles, :id => false do |t|
      t.integer  :mp_id
      t.integer  :news_article_id
    end
    create_table :senators_news_articles, :id => false do |t|
      t.integer  :senator_id
      t.integer  :news_article_id
    end
  end

  def self.down
    drop_table :news_articles
    drop_table :mps_news_articles
    drop_table :senators_news_articles
  end
end
