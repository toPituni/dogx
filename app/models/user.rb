class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # have a look at this
  has_many :walks
  has_many :dogs

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  
end
