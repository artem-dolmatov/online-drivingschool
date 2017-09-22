class CreateUserTopics < ActiveRecord::Migration
  def change
    create_table :user_topics do |t|
      t.references :user, index: true, foreign_key: true
      t.references :topic, index: true, foreign_key: true
      t.integer :done

      t.timestamps null: false
    end
  end
end
