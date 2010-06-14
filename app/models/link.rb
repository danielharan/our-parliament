class Link < ActiveRecord::Base
  named_scope :glossary, :conditions => {:category => "glossary"}
  named_scope :article, :conditions => {:category => "article"}
end
