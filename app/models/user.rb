class User < ActiveRecord::Base
  attr_accessible :phone_number, :name, :email,:image_url

  has_one :apid_user

  def push_notification(message)
    reg_id = self.apid_user
    sender = MessageSender.new
    sender.push_user_payload(reg_id.device, message, reg_id.value)
  end
end
