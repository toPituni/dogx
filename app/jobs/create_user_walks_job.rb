class CreateUserWalksJob < ApplicationJob
  queue_as :default

  def perform(schedule_id)
    WalkService.new(schedule_id).create
  end
end
