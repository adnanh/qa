class PrivateMessage < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :receiver_id

  attr_accessor :title, :content

  validates_presence_of :title, :content, :sender_status, :receiver_status, :sender, :receiver

  validates_length_of :title, :maximum => 255, :allow_blank => false
  validates_length_of :content, :maximum => 10000, :allow_blank => false

  SENDER_STATUS = {draft: 0, sent: 1, deleted: 2}
  RECEIVER_STATUS = {unread: 0, read: 1, deleted: 2}

  def sender_status
    SENDER_STATUS.key(read_attribute(:sender_status))
  end

  def sender_status_id
    read_attribute(:sender_status)
  end

  def sender_status=(s)
    if (s.is_a? Integer)
      write_attribute(:sender_status,s)
    else
      write_attribute(:sender_status,SENDER_STATUS[s])
    end
  end

  def receiver_status
    RECEIVER_STATUS.key(read_attribute(:receiver_status))
  end



  def receiver_status_id
    read_attribute(:receiver_status)
  end

  def receiver_status=(s)
    if (s.is_a? Integer)
      write_attribute(:receiver_status,s)
    else
      write_attribute(:receiver_status,RECEIVER_STATUS[s])
    end
  end

end
