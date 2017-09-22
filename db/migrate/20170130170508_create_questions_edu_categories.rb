class CreateQuestionsEduCategories < ActiveRecord::Migration
  def change
    create_table :questions_edu_categories do |t|
      t.integer :question_id
      t.integer :edu_category_id

      t.timestamps null: false
    end
  end
end
