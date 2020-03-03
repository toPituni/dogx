class Dog < ApplicationRecord
  has_many :slots
  has_many :walks, through: :slots
  
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def address
    self.pick_up_address
  end
end
