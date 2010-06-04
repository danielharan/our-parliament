class ParliamentaryTitle < ActiveRecord::Base
  translatable_columns :name, :role
  
  def full_name
    name.index(role) == nil ? "#{name} #{role}" : name
  end
  
end
