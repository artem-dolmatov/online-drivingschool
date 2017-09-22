class CreateUsersEduCategories < ActiveRecord::Migration
  def change
    create_table :users_edu_categories do |t|

      t.integer :user_id
      t.integer :edu_category_id
      t.timestamps null: false
    end
  end
end
