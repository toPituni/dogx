class Walk < ApplicationRecord
   has_many :slots
   has_many :dogs, through: :slots
end
