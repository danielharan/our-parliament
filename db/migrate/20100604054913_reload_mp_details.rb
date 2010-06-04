class ReloadMpDetails < ActiveRecord::Migration
  def self.up
    Committee.delete_all
    CommitteeMembership.delete_all
    ParliamentaryFunction.delete_all
    
    remove_column :committees, :name
    add_column :committees, :name_en, :string
    add_column :committees, :name_fr, :string
    
    remove_column :committee_memberships, :role
    add_column :committee_memberships, :committee_role_id, :integer
    
    remove_column :parliamentary_functions, :role
    remove_column :parliamentary_functions, :title
    add_column :parliamentary_functions, :parliamentary_title_id, :integer
    
    data_dir = File.join(RAILS_ROOT, 'db', 'mp_data')
    Dir.foreach(data_dir) { |file|
      if file != '.' and file != '..'
        mp_info = JSON.parse(open(File.join(data_dir, file)).read)
        mp = Mp.find_by_name(mp_info['name'])
        if mp
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
        end
      end
     }
  end

  def self.down
    ParliamentaryFunction.delete_all
    Committee.delete_all
    CommitteeMembership.delete_all
    
    add_column :committees, :name, :string
    remove_column :committees, :name_en
    remove_column :committees, :name_fr
    
    add_column :committee_memberships, :role, :string
    remove_column :committee_memberships, :committee_role_id
    
    add_column :parliamentary_functions, :role, :string
    add_column :parliamentary_functions, :title, :string
    remove_column :parliamentary_functions, :parliamentary_title_id
    
  end
end
