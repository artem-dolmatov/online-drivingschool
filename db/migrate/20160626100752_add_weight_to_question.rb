class AddWeightToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :weight, :integer
  end
end
