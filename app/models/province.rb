class Province < ActiveRecord::Base
  translatable_columns :name
  has_many :ridings
  has_many :senators
  has_many :mps, :order => "name"
end
