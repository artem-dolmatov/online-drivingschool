class AddTicketToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :ticket, :integer, :default => 0
  end
end
