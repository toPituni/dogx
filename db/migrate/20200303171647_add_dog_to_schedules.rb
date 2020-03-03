class AddDogToSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :schedules, :dog, foreign_key: true
  end
end
