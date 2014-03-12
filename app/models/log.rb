class Log < ActiveRecord::Base

  validates :description, :ip_address,  :presence => true

  validates_length_of :ip_address, :maximum => 15, :allow_blank => false

  def self.log(message, ip)
    log = Log.new
    log.description = message
    log.ip_address = ip
    log.save
  end

end
