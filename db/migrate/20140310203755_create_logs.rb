class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :ip_address, :limit => 15, :null => false
      t.string :description, :null => false

      t.timestamps
    end
  end
end
