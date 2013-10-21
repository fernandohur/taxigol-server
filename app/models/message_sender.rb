require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'

class MessageSender

  #
  # Constants
  #

  # api url used for broadcasting messages
  URBAN_AIRSHIP_API_URL = 'https://go.urbanairship.com/api/push/broadcast/'
  # urban airship app key used for the driver app
  DRIVER_APP_KEY = ENV['URBAN_AIRSHIP_APP_KEY']
  # urban airship master secret key used for driver app
  DRIVER_MASTER_KEY = ENV['URBAN_AIRSHIP_MASTER_SECRET']
  # urban airship app key used for the user's app
  USER_APP_KEY = ENV['USER_APP_KEY_UA']
  # urban airship master secret key used for user' app
  USER_MASTER_KEY = ENV['USER_APP_MASTER_SECRET_UA']

  def initialize
    @uri = URI(URBAN_AIRSHIP_API_URL)
  end

  def push_general()

  end

  # Sets the keys to be used by the MessageSender
  def set_keys(app_key, master_secret_key)
    @appKey = app_key
    @masterSecret = master_secret_key
    raise RuntimeError "appkey cannot be nil" unless @appKey
    raise RuntimeError "master secret key cannot bil" unless @masterSecret
  end

  # set the keys used by the user app
  def attr_user_app
    set_keys(USER_APP_KEY,USER_MASTER_KEY)
  end

  # set the keys used by the driver app
  def attr_taxi_app
    set_keys(DRIVER_APP_KEY,DRIVER_MASTER_KEY)
  end

	def push(payload_json)
		req = Net::HTTP::Post.new(@uri.path)
    req.content_type = 'application/json'
    req.basic_auth @appKey,@masterSecret 
    req.body = payload_json
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    return http.request(req)
  end

  def push_default(alert,key,value)
    push(get_android_payload(alert,{key=>value,:action=>'default'}))
  end

  def push_payload(alert, key_values={})
    push(get_android_payload(alert,key_values))
  end

  def get_android_payload(alert, key_values={})
    json_payload={
        :android=>{
            :alert=>alert,
            :extra=>key_values
        },
        :options=>{
        :expiry => "300"
        }
    }.to_json
    return json_payload
  end

  def push_user_payload(device, alert, reg_id)
    if device=="iOS"
      push(get_ios_user_payload(alert, reg_id))
    elsif device=="Android"
      push(get_android_user_payload(alert, reg_id))
    else
      puts("---no se pueden enviar notificaciones a otros dispositivos----")
    end
  end

  def get_ios_user_payload(alert, dev_token)
    json_payload={
        :device_tokens=>[dev_token],
        :aps=> {
        :alert=>alert
    }
    }.to_json
    return json_payload
  end

  def get_android_user_payload(alert, user_apid)
    json_payload={
        :apids=>[user_apid],
        :android=>{
            :alert=>alert
        }
    }.to_json
    return json_payload
  end



end


