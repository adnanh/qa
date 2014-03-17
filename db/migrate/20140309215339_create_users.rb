class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :limit => 16, :null => false, :unique => true
      t.string :flair, :limit => 255, :default => ""
      t.boolean :banned, :null => false, :default => false
      t.integer :karma, :null => false, :default => 0
      t.boolean :email_public, :null => false, :default => false

      t.integer :user_privilege_id, :null => false

      t.timestamps
    end

    add_index :users, :username, :unique => true

    add_foreign_key 'users', 'user_privileges', name: 'users_user_privilege_id_fk'
  end
end
