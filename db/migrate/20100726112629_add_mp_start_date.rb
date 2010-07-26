class AddMpStartDate < ActiveRecord::Migration
  def self.up
    add_column :mps, :start_date, :date
    
    data_dir = File.join(RAILS_ROOT, 'db', 'mp_data')
    Dir.foreach(data_dir) { |file|
      if file != '.' and file != '..'
        mp_info = JSON.parse(open(File.join(data_dir, file)).read)
        mp = reconcile_mp(mp_info)
        if mp
          if mp_info['start_date']
            mp.start_date = Date.strptime(mp_info['start_date'])
            mp.save
          end
        else
          puts "Unmatched MP: #{mp_info['name']}"
        end
      end
    }
  end

  def self.down
    remove_column :mps, :start_date
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
    #mp = Mp.find_by_parl_gc_id(mp_info['parlinfo_id']) if not mp and mp_info['parlinfo_id']
    return mp
  end
  
end
