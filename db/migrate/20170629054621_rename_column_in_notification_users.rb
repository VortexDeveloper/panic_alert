class RenameColumnInNotificationUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :notification_users, :user_id, :destiny_id
  end
end
