class CreateDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :pick_up_address
      t.string :image
      t.string :breed
      t.string :special_requirements
      t.references :owner
      t.references :user
      t.references :schedule

      t.timestamps
    end
  end
end
