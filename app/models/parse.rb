require 'httparty'
require 'json'

class Parse
  include HTTParty
  base_uri "api.parse.com:443"
  headers "X-Parse-Application-Id" => "JmIwXNLu8zHPrknllt7ISSKHtPaIK6rwCTLVcMJ9", "X-Parse-REST-API-Key" =>  "x3RSWnX1jRoDYHKCIsxDLxegoUxkFLf72XsKJFh4", "Content-Type" => "application/json"

  # Sends a Panic Push message to all suscribers to the Giant channel
  def Parse.send_panic_push(position)
    raise NoPositionError, "Position must not be nil for a panic push" if position == nil
    option = {:channel => "Giants", :data => {:alert => "Servicio de panico", :action => "com.fer.taxis.PANIC_SERVICE", :lat => position.latitude, :lon => position.longitude}}
    Parse.post("/1/push", body: option.to_json)

  end

  def Parse.send_service_create(service)
    option = {:channel => "Giants", :data => {:action => "com.fer.taxis.TAXI_SERVICE",:id => service.id}}
    Parse.post("/1/push", body: option.to_json)
  end


end


