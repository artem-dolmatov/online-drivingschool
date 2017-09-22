class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.references :city, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
