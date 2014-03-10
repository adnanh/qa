class PasswordRecoveryToken < ActiveRecord::Base
  belongs_to :user

  attr_accessor :recovery_hash, :user_id

  validates :recovery_hash, :user_id, :presence => true, :uniqueness => true

  validates_length_of :recovery_hash, :maximum => 32, :allow_blank => false
end
