require 'uri'

module ApplicationHelper

  def translate_link(uri, locale)
    host = locale == "fr" ? "www.fabriquecitoyenne.com" : "www.citizenfactory.com"
    return "http://#{host}#{uri}"
  end

end
