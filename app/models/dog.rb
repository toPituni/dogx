class Dog < ApplicationRecord
  has_one :schedule
  has_many :slots
  has_many :walks, through: :slots
  belongs_to :owner

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_pick_up_address?

  def address
    self.pick_up_address
  end

end
