class User < ActiveRecord::Base
  belongs_to :user_privilege
  has_many :votes
  has_many :questions
  has_many :answers
  has_many :sent_private_messages, :foreign_key => 'sender_id', :class_name => 'PrivateMessage'
  has_many :received_private_messages, :foreign_key => 'receiver_id', :class_name => 'PrivateMessage'

  attr_accessor :username, :password, :salt, :flair, :banned, :email, :karma, :email_public, :last_login, :activated, :activation_code

  validates :username, :password, :salt, :banned, :email, :karma, :email_public, :activated, :user_privilege_id, :presence => true
  validates :username, :email, :activation_code, :uniqueness => true

  validates :banned, :activated, :email_public, inclusion: [true, false]

  validates_length_of :username, :maximum => 16, :allow_blank => false
  validates_length_of :password, :maximum => 32, :allow_blank => false
  validates_length_of :salt, :maximum => 45, :allow_blank => false
  validates_length_of :flair, :maximum => 32
  validates_length_of :email, :maximum => 255, :allow_blank => false
  validates_length_of :activation_code, :maximum => 45
end
