class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  belongs_to :user_privilege
  has_many :votes
  has_many :questions
  has_many :answers
  has_many :sent_private_messages, :foreign_key => 'sender_id', :class_name => 'PrivateMessage'
  has_many :received_private_messages, :foreign_key => 'receiver_id', :class_name => 'PrivateMessage'

  has_attached_file :image, :styles => {
      :thumb => "100x100#",
      :small  => "150x150>",
      :medium => "200x200" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  before_create :set_default_privileges

  validates :username, :email, :uniqueness => true

  def set_default_privileges
    self.user_privilege_id = 1
  end

  #validates :username, :banned, :email, :karma, :email_public, :user_privilege_id, :presence => true
  #validates :banned, :activated, :email_public, inclusion: [true, false]

  #validates_length_of :username, :maximum => 16, :allow_blank => false
  #validates_length_of :flair, :maximum => 32
  #validates_length_of :email, :maximum => 255, :allow_blank => false
end
