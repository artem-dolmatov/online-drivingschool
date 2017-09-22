class AddExamToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :exam, :integer
  end
end
