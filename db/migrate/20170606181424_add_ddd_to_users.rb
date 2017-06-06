class AddDddToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :ddd, :string, null: false, limit: 2
    change_column :users, :cellphone, :string, null:false, limit: 9
  end
end
