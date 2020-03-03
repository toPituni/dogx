class Dog < ApplicationRecord
  has_one :schedule
  has_many :slots
  has_many :walks, through: :slots
end
