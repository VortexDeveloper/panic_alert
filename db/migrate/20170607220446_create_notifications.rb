class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.text :message
      t.string :title
      t.string :profile
      t.text :android_payload
      t.text :ios_payload
      t.date :scheduled
      t.integer :production, limit: 1

      t.timestamps
    end
  end
end
