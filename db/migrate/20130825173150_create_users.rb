class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :password_digest
      t.string :api_key
      t.boolean :admin

      t.timestamps
    end
  end
end
