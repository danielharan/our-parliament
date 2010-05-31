class Riding < ActiveRecord::Base
  translatable_columns :name
  belongs_to :province
end
