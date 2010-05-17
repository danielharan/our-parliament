require 'json'

class BootstrapHansardData < ActiveRecord::Migration
  def self.up
    data_dir = File.join(RAILS_ROOT, 'db', 'hansard_data')
    Dir.foreach(data_dir) { |file|
      if file != '.' and file != '..'
        hansard_info = JSON.parse(open(File.join(data_dir, file)).read)
        hansard = {
          :date => hansard_info['date'],
          :parliament => hansard_info['parliament'],
          :session => hansard_info['session'],
          :url => hansard_info['original_url']
        }
        hansard_info['statements'].each { |statement_info|
          statement = {
            :hansard_id => hansard_info['id'],
            :parliament => hansard_info['parliament'],
            :session => hansard_info['session'],
            :time => statement_info['time'],
            :attribution => statement_info['attribution'],
            :heading => statement_info['heading'],
            :topic => statement_info['topic'],
            :text => statement_info['text'],
          }
          if statement_info['politician']
            statement[:member_name] = statement_info['politician']['name']
            statement[:member_id] = statement_info['politician']['member_id']
          end
          HansardStatement.new(statement).save
        }
        h = Hansard.new(hansard)
        h.id = hansard_info['id']
        h.save
      end
     }
  end

  def self.down
    HansardStatement.delete_all
    Hansard.delete_all
  end
end
