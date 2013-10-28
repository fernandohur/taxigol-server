class UserMessageSender

  # urban airship app key used for the driver app
  USER_APP_KEY = ENV['USER_APP_KEY_UA']
  # urban airship master secret key used for driver app
  USER_MASTER_KEY = ENV['USER_APP_MASTER_SECRET_UA']
  #Urban airship app secret key used for driver app
  USER_APP_SECRET = ENV['USER_APP_SECRET']

  def initialize
    @client = Urbanairship::Client.new
    @client.application_key = USER_APP_KEY
    @client.application_secret = USER_APP_SECRET
    @client.master_secret = USER_MASTER_KEY
    @client.logger = Rails.logger
    @client.request_timeout = 5 # default
    @options = {
        :expiry => "0"
    }
  end

  def notify_user_app(alert, user_id)
    user = User.find(user_id)
    apid_user = user.apid_user
    reg_id = apid_user.value
    device = apid_user.device
    if device.casecmp("iOS") == 0
      notify_ios_app(alert, reg_id)
    elsif device.casecmp("Android") == 0
      notify_android_app(alert, reg_id)
    else
      puts("---no se pueden enviar notificaciones a otros dispositivos----")
    end
  rescue ActiveRecord::RecordNotFound
    puts '---- No se encontro el user para notificar ---'
  end

  def notify_ios_app(alert, dev_token)
    notification = {
        :device_tokens => [dev_token],
        :aps => {
            :alert => alert,
            :sound => 'default'
        }
    }
    @client.push(notification)
  end

  def notify_android_app(alert, apid)
    notification = {
        :apids => [apid],
        :android => {
            :alert => alert
        }
    }
    @client.push(notification)
  end



end