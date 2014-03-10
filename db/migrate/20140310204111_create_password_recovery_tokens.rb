class CreatePasswordRecoveryTokens < ActiveRecord::Migration
  def change
    create_table :password_recovery_tokens do |t|
      t.integer :user_id, :null => false
      t.string :recovery_hash, :limit => 32, :null => false

      t.timestamps
    end

    add_index :password_recovery_tokens, :recovery_hash, :unique => true
    add_index :password_recovery_tokens, :user_id, :unique => true
    add_foreign_key 'password_recovery_tokens', 'users', name:'password_recovery_token_user_id_fk'
  end
end
