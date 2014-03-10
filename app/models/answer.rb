class Answer < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :editor, :class_name => 'User', :foreign_key => :editor_id
  belongs_to :question
  has_many :votes, :as => :disqsable

  attr_accessor :author, :content, :editor, :question, :votes

  validates_presence_of :author, :content

  validates_length_of :content, :maximum => 10000, :allow_blank => false
end
