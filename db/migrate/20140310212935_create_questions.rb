class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :author_id, :null => false
      t.integer :editor_id
      t.string :title, :limit => 255, :null => false
      t.text :content, :limit => 10000, :null => false
      t.string :tags, :limit => 255, :null => false
      t.boolean :open, :null => false
      t.integer :views, :null => false
      t.string :status_description, :limit => 1000

      t.timestamps
    end

    add_foreign_key 'questions', 'users', name: 'questions_author_id_fk', column: 'author_id'
    add_foreign_key 'questions', 'users', name: 'questions_editor_id_fk', column: 'editor_id'
  end
end
