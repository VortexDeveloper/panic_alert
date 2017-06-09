class AddSenderToNotification < ActiveRecord::Migration[5.1]
  def change
    add_reference :notifications, :sender, foreign_key: { to_table: :users }
  end
end
