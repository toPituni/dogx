class CreateWalks < ActiveRecord::Migration[5.2]
  def change
    create_table :walks do |t|
      t.date :date
      t.references :user

      t.timestamps
    end
  end
end
