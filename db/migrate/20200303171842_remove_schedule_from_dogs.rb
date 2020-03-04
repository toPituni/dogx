class RemoveScheduleFromDogs < ActiveRecord::Migration[5.2]
  def self.down
      remove_column :dogs, :schedule_id
  end
end
