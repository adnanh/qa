class AddAcceptedToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :accepted, :boolean, :null => false, :default => false
  end
  def self.down
    remove_column :answers, :accepted, :boolean, :null => false, :default => false
  end
end
