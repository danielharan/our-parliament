class Party < ActiveRecord::Base
  translatable_columns :name
  has_many :mps
  
  def active_mps
    return Mp.find_all_active_by_party_id(id)
  end
  
end
