class Log < ActiveRecord::Base
  attr_accessor :description, :ip_address

  validates :description,  :presence => true

  validates_length_of :ip_address, :maximum => 15, :allow_blank => false

  def self.log(message)
    request = Thread.current[:request]
    log = Log.new
    log.description = message
    log.save
  end

end
