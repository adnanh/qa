class CreateUserPrivileges < ActiveRecord::Migration
  def change
    create_table :user_privileges do |t|
      t.string :name, :limit => 45, :null => false, :unique => true
      t.string :description, :limit => 255, :null => false

      t.timestamps
    end

    add_index :user_privileges, :name, :unique => true
  end
end
