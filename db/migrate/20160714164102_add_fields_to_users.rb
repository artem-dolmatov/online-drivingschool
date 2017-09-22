class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_reference :users, :city, index: true, foreign_key: true
  end
end
