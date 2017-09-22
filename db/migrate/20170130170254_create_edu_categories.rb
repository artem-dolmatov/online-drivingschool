class CreateEduCategories < ActiveRecord::Migration
  def change
    create_table :edu_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
