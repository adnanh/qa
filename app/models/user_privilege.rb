class UserPrivilege < ActiveRecord::Base
  has_many :users

  attr_accessor :name, :description

  validates :name, :description, :presence => true
  validates :name, :uniqueness => true

  validates_length_of :name, :maximum => 45, :allow_blank => false
  validates_length_of :description, :maximum => 255, :allow_blank => false
end
