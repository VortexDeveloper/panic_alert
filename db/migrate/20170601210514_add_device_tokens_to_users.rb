class AddDeviceTokensToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :device_token, :text
    add_column :users, :device_type, :text
  end

  def down
    remove_column :users, :device_tokens
  end
end
