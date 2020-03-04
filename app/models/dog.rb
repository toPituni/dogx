class Dog < ApplicationRecord
  has_many :slots
  has_many :walks, through: :slots
  belongs_to :owner
end
