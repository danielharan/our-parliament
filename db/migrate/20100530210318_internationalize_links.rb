class InternationalizeLinks < ActiveRecord::Migration
  def self.up
    add_column :links, :locale, :string
    Link.update_all("locale = \"en\"")
  end

  def self.down
    remove_column :links, :locale
  end
end
