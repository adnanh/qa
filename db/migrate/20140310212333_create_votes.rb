class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :value, :null => false
      t.integer :user_id, :null => false
      t.references :disqsable, :polymorphic => true

      t.timestamps
    end

    add_foreign_key 'votes', 'users', name: 'votes_user_id_fk'
  end
end
