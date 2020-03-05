class Walk < ApplicationRecord
   has_many :slots
   has_many :dogs, through: :slots
   # have a look at this
   belongs_to :user
end
