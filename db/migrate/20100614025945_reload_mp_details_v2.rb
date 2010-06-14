require 'yaml'

class ReloadMpDetailsV2 < ActiveRecord::Migration
  
  def self.up
    party_aliases = {}
    alias_data = YAML::load_file(File.join(RAILS_ROOT, 'db', 'party_data', 'party_aliases.yml'))
    alias_data.each { |key,value|
      value.each{ |party_alias|
        party_aliases[party_alias] = key
      }
    }
    
    Committee.delete_all
    CommitteeMembership.delete_all
    ParliamentaryFunction.delete_all
    
    data_dir = File.join(RAILS_ROOT, 'db', 'mp_data')
    Dir.foreach(data_dir) { |file|
      if file != '.' and file != '..'
        mp_info = JSON.parse(open(File.join(data_dir, file)).read)
        mp = reconcile_mp(mp_info)
        if mp
          current_party = mp_info["parties"][0]["name_en"]
          party = reconcile_party(current_party, party_aliases)
          if party
            mp.party_id = party.id
          else
            puts "Unmatched party: #{current_party}"
          end
          mp_info['functions'].each { |f|
            title = ParliamentaryTitle.find_by_name_en(f['title_en'])
            if not title
              title = ParliamentaryTitle.create({
                :name_en => f['title_en'],
                :name_fr => f['title_fr'],
                :role_en => f['role_en'],
                :role_fr => f['role_fr']
              })
            end
            parliamentary_function = ParliamentaryFunction.create({
              :mp_id => mp.id,
              :parliamentary_title_id => title.id,
              :start_date => f['start_date'],
              :end_date => f['end_date']
            })
          }
          mp_info['committees'].each { |c|
            committee = Committee.find_by_name_en(c['name_en'])
            if not committee
              committee = Committee.create({
                :name_en => c['name_en'],
                :name_fr => c['name_fr']
              })
            end
            role = CommitteeRole.find_by_name_en(c['role_en'])
            if not role
              role = CommitteeRole.create({
                :name_en => c['role_en'],
                :name_fr => c['role_fr']
              })
            end
            committee_membership = CommitteeMembership.create({
              :mp_id => mp.id,
              :committee_id => committee.id,
              :committee_role_id => role.id,
              :parliament => c['parliament'],
              :session => c['session']
            })
          }
          mp.date_of_birth = mp_info["date_of_birth"] if mp_info["date_of_birth"]
          mp.place_of_birth = mp_info["place_of_birth"] if mp_info["place_of_birth"]
          mp.save
        else
          puts "Unmatched MP: #{mp_info['name']}"
        end
      end
     }
  end

  def self.down
  end

  private
  
  def self.reconcile_party(current_party, party_aliases)
    if party_aliases.include?(current_party)
      current_party = party_aliases[current_party]
    end
    party = Party.find_by_name_en(current_party)
    return party
  end
  
  def self.reconcile_mp(mp_info)
    mp = Mp.find_by_name(mp_info['name'])
    if not mp
      phone_number = mp_info['contact_info']['parliament']['telephone'] if mp_info['contact_info']['parliament']
      phone_number = phone_number.gsub(/^(\d{3})-/, '(\1)  ') if phone_number
      mp = Mp.find_by_parliamentary_phone(phone_number) if phone_number
    end
    if not mp
      website = nil
      mp_info['weblinks'].each { |weblink|
        website = weblink['url_en'] if weblink['name_en'] =~ /^Personal Website/
      }
      mp = Mp.find_by_website(website) if website
    end
    mp = Mp.find_by_email(mp_info['contact_info']['parliament']['email']) if not mp and mp_info['contact_info']['parliament'] and mp_info['contact_info']['parliament']['email'] 
    mp = Mp.find_by_parl_gc_id(mp_info['parlinfo_id']) if not mp and mp_info['parlinfo_id']
    return mp
  end

end
