class Schedule < ApplicationRecord
  belongs_to :dog
  after_create :make_user_walks # Run on create
  after_update :update_user_walks

  private

  def make_user_walks
    CreateUserWalksJob.perform_now(self.id)
  end

  def update_user_walks
    UpdateUserWalksJob.perform_now(self.id)
  end
end
