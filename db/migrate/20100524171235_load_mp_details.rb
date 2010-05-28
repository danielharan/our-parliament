require 'json'

class LoadMpDetails < ActiveRecord::Migration
  def self.up
    data_dir = File.join(RAILS_ROOT, 'db', 'mp_data')
    Dir.foreach(data_dir) { |file|
      if file != '.' and file != '..'
        mp_info = JSON.parse(open(File.join(data_dir, file)).read)
        mp = Mp.find_by_name(mp_info['name'])
        if mp
          mp_info['functions'].each { |f|
            parliamentary_function = ParliamentaryFunction.new(f)
            parliamentary_function.mp_id = mp.id
            parliamentary_function.save
          }
          mp_info['committees'].each { |c|
            committee = Committee.find_or_create_by_name(c['committee'])
            committee_membership = CommitteeMembership.new({
              :mp_id => mp.id,
              :committee_id => committee.id,
              :role => c['role'].strip,
              :parliament => c['parliament'],
              :session => c['session']
            })
            committee_membership.save
          }
          mp.date_of_birth = mp_info["date_of_birth"] if mp_info["date_of_birth"]
          mp.place_of_birth = mp_info["place_of_birth"] if mp_info["place_of_birth"]
          mp.save
        end
      end
     }
  end

  def self.down
    ParliamentaryFunction.delete_all
    Committee.delete_all
    CommitteeMembership.delete_all
  end
end
