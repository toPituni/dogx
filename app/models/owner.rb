class Owner < ApplicationRecord
  has_many :dogs, inverse_of: :owner
  accepts_nested_attributes_for :dogs
end
