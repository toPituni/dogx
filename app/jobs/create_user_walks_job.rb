class CreateUserWalksJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    WalkService.new(user_id).create
  end
end
