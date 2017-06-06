class AddDisplayNameToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :display_name, :string
  end
end
