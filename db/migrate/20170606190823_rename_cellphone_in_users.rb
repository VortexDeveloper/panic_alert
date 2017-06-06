class RenameCellphoneInUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :cellphone, :phone_number
  end
end
