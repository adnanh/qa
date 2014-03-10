class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.string :title, :limit => 255, :null => false
      t.text :content, :limit => 10000, :null => false
      t.integer :sender_id, :null => false
      t.integer :receiver_id, :null => false
      t.integer :sender_status, :null => false
      t.integer :receiver_status, :null => false

      t.timestamps
    end

    add_foreign_key 'private_messages', 'users', name: 'private_messages_receiver_id_fk', column: 'receiver_id'
    add_foreign_key 'private_messages', 'users', name: 'private_messages_sender_id_fk', column: 'sender_id'
  end
end
