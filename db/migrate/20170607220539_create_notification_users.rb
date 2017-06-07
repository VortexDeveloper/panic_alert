class CreateNotificationUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_users do |t|
      t.references :notification, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
