class RemoveScheduleFromDogs < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :dogs, column: :schedule_id
  end
end
