class AddStatusToNotificationUser < ActiveRecord::Migration[5.1]
  def change
    add_column :notification_users, :status, :integer
  end
end
