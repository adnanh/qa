class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :author_id, :null => false
      t.integer :editor_id
      t.integer :question_id, :null => false
      t.text :content, :limit => 10000, :null => false
      t.boolean :accepted, :null => false, :default => false

      t.timestamps
    end

    add_foreign_key 'answers', 'users', name: 'answers_author_id_fk', column: 'author_id'
    add_foreign_key 'answers', 'users', name: 'answers_editor_id_fk', column: 'editor_id'
    add_foreign_key 'answers', 'questions', name: 'answers_question_id_fk'
  end
end
