class Schedule < ApplicationRecord
  belongs_to :dog
  after_save :make_user_walks # Run on create & update

  private

  def make_user_walks
    CreateUserWalksJob.perform_now(self.id)
  end
end
