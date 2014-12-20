class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.integer :user_id, :null => false
      t.string :tag, :limit => 255, :null => false
      t.timestamps
    end

    add_foreign_key 'followings', 'users', name: 'followings_user_id_fk', column: 'user_id'
  end
end
