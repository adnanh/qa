class Question < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :editor, :class_name => 'User', :foreign_key => :editor_id
  has_many :answers
  has_many :votes, :as => :disqsable

  attr_accessor :author, :title, :content, :tags, :open, :status_description, :views, :editor

  validates_presence_of :author, :title, :content, :tags, :open, :views

  validates_length_of :title, :maximum => 255, :allow_blank => false
  validates_length_of :content, :maximum => 10000, :allow_blank => false
  validates_length_of :status_description, :maximum => 1000

  validates :open, inclusion: [true, false]
  validates :views, :numericality => { :greater_than_or_equal_to => 0 }
end