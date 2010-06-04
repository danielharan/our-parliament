class ParliamentaryFunction < ActiveRecord::Base
  belongs_to :mp
  belongs_to :parliamentary_title
end
