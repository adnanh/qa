class Vote < ActiveRecord::Base
  belongs_to :disqsable, :polymorphic => true
  belongs_to :user

  attr_accessor :user_id, :disqsable, :value

  validates_presence_of :user, :disqsable, :value

  # true => upvote; false => downvote
  validates :value, inclusion: [true, false]
end
