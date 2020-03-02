class CreateSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :slots do |t|
      t.integer :status
      t.integer :place
      t.references :walk, foreign_key: true
      t.references :dog, foreign_key: true

      t.timestamps
    end
  end
end
