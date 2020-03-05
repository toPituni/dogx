class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # have a look at this
  has_many :walks

  after_create :make_user_walks # Run on create & update

  private

  def make_user_walks
    CreateUserWalksJob.perform_later(self.id)
  end
end
