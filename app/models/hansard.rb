require 'open-uri'
require 'json'

class Hansard < ActiveRecord::Base
  
  has_many :statements, :class_name => 'HansardStatement'
  
  def self.get_list
    data = open("http://openparliament.ca/api/hansards/")
    return data ? JSON.parse(data.read) : nil
  end
  
  def self.fetch(hansard_id)
    begin
      data = open("http://openparliament.ca/api/hansards/#{hansard_id}/")
    rescue
      logger.error "Unable to find hansard #{hansard_id}"
    end
    return data ? JSON.parse(data.read) : nil
  end
  
end
