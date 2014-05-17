class Answer < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :editor, :class_name => 'User', :foreign_key => :editor_id
  belongs_to :question
  has_many :votes, :as => :disqsable, :dependent => :destroy


  validates_presence_of :author, :content

  validates :accepted, inclusion: [true, false]

  validates_length_of :content, :minimum=>10, :maximum => 10000, :allow_blank => false
end
