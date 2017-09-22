class AddWeightToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :weight, :integer
  end
end
