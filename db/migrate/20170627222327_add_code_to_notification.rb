class AddCodeToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :code, :string
  end
end
