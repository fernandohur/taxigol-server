require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'

class MessageSender

  def initialize
    @uri = URI('https://go.urbanairship.com/api/push/broadcast/')
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
    push(get_payload(alert,{key=>value,:action=>'default'}))
  end

  def push_payload(alert, key_values={})
    push(get_payload(alert,key_values))
  end

  def get_default_payload(alert, key, value)
    get_payload alert, {key=>value}
  end

  def get_payload(alert, key_values={})
    json_payload={
        :android=>{
            :alert=>alert,
            :extra=>key_values
        }
    }.to_json
    return json_payload
  end

end


