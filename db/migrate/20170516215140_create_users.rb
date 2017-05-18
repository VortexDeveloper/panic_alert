class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :cellphone
      t.string :authentication_token

      t.timestamps

      t.index :username, unique: true
      t.index :email, unique: true
      t.index :cellphone, unique: true
      t.index :authentication_token, unique: true
    end
  end
end
