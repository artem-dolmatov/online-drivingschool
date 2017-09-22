class AddPhoneToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :phone, :string
  end
end
