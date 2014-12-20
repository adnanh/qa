class Following < ActiveRecord::Base
  belongs_to :user

  validates_format_of :tag, :with => /\A\S*\z/
  validates_length_of :tag, :allow_blank => false, :minimum => 1, :maximum => 255
end
