class Party < ActiveRecord::Base
  translatable_columns :name
  has_many :mps
end
