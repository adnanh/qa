class Question < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id
  belongs_to :editor, :class_name => 'User', :foreign_key => :editor_id
  has_many :answers, :dependent => :destroy
  has_many :votes, :as => :disqsable, :dependent => :destroy

  validates_presence_of :author, :title, :content, :tags, :views

  validates_length_of :title, :minimum=>4, :maximum => 255, :allow_blank => false
  validates_length_of :content, :minimum => 10, :maximum => 10000, :allow_blank => false
  validates_length_of :status_description, :maximum => 1000

  validates :open, inclusion: [true, false]
  validates :views, :numericality => { :greater_than_or_equal_to => 0 }

  # teaching Question how to handle text search
  search_syntax do

    search_by :text do |scope, phrases|
      columns = [:title, :tags]
      scope.where_like(columns => phrases)

    end

  end
end
