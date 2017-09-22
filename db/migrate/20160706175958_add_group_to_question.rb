class AddGroupToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :group, :integer
  end
end
