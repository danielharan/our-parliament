class Link < ActiveRecord::Base
  named_scope :glossary, :conditions => {:category => "glossary", :locale => I18n.locale}
  named_scope :article, :conditions => {:category => "article", :locale => I18n.locale}
end
