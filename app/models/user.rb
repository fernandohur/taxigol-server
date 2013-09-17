class User < ActiveRecord::Base
  attr_accessible :phone_number, :name, :email,:image_url

  has_one :apid_user

  def push_notification(message)
    reg_id = self.apid_user
    sender = MessageSender.new
    sender.attr_user_app
    sender.push_user_payload(reg_id.device, message, reg_id.value)
  end

  def User.search_user(cel)
    user = nil
    if cel != ""
      user = User.find_by_phone_number(cel)
    end

    return user
  end
end
