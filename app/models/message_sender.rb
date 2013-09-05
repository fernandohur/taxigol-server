require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'

class MessageSender

  def initialize
    @uri = URI('https://go.urbanairship.com/api/push/broadcast/')
    attr_taxi_app
  end

  def attr_taxi_app
    @appKey = ENV["URBAN_AIRSHIP_APP_KEY"]#'yO9cF34tTVSVKU8R1Qu7fw'
    @masterSecret = ENV["URBAN_AIRSHIP_MASTER_SECRET"]#'7TXRczMdQeKwUEg-5LSS5A'
    raise RuntimeError unless @appKey
    raise RuntimeError unless @masterSecret
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

  def get_default_payload(alert, key, value)
    get_android_payload alert, {key=>value}
  end

  def get_android_payload(alert, key_values={})
    json_payload={
        :android=>{
            :alert=>alert,
            :extra=>key_values
        }
    }.to_json
    return json_payload
  end

  def attr_user_app
    @appKey = ENV["USER_APP_KEY_UA"]
    @masterSecret = ENV["USER_APP_MASTER_SECRET_UA"]
  end

  def push_user_payload(device, alert, reg_id)
    if(device=="iOS")
      push(get_ios_user_payload(alert, reg_id))
    elsif(device=="Android")
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


