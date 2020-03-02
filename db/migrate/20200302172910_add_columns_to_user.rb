class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_column :users, :capacity, :integer
    add_column :users, :company_name, :string
    add_reference :users, :destination, foreign_key: true
  end
end
