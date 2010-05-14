namespace :update do
  desc "update the list of hansard statements from the Open Parliament API"
  task :hansards => :environment do
    Hansard.get_list.each { |hansard_list_info|
      hansard_info = Hansard.fetch(hansard_list_info['id'])
      if hansard_info
        hansard = {
          :date => hansard_info['date'],
          :parliament => hansard_info['parliament'],
          :session => hansard_info['session'],
          :num => hansard_list_info['number'],
          :url => hansard_info['original_url']
        }
        hansard_info['statements'].each { |statement_info|
          statement = {
            :hansard_id => hansard_info['id'],
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
end