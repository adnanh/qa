class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :limit => 16, :null => false, :unique => true
      t.string :password, :limit => 32, :null => false
      t.string :salt, :limit => 45, :null => false
      t.string :flair, :limit => 255
      t.boolean :banned, :null => false, :default => false
      t.string :email, :limit => 255, :null => false, :unique => true
      t.integer :karma, :null => false, :default => 0
      t.boolean :email_public, :null => false, :default => false
      t.timestamp :last_login
      t.boolean :activated, :null => false, :default => false
      t.string :activation_code, :limit => 45

      t.integer :user_privilege_id, :null => false

      t.timestamps
    end

    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true

    add_foreign_key 'users', 'user_privileges', name:'users_user_privilege_id_fk'
  end
end
