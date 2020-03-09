class Walk < ApplicationRecord
   has_many :slots, dependent: :destroy
   has_many :dogs, through: :slots
   # have a look at this
   belongs_to :user
   validates :date, uniqueness: true
end
