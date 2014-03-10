class Log < ActiveRecord::Base
  attr_accessor :description, :ip_address

  validates :description, :ip_address, :presence => true

  validates_length_of :ip_address, :maximum => 15, :allow_blank => false

  def self.log(message)
    request = Thread.current[:request]
    log = Log.new
    log.description = message
    log.ip_address = request.remote_ip
    log.save
  end
end
