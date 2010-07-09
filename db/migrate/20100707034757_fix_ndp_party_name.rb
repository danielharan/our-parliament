class FixNdpPartyName < ActiveRecord::Migration
  def self.up
    party = Party.find_by_name_en('NDP-New Democratic Party')
    party.name_en = 'New Democratic Party'
    party.name_fr = 'Nouveau Parti démocratique'
    party.save
  end

  def self.down
  end
end
