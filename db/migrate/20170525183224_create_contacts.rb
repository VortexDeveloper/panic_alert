class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.references :user, foreign_key: true
      t.integer :emergency_contact_id, references: :users, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
