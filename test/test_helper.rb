ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def should_contain_error_message(response, exception_class)

    resp = MultiJson.load(response.body)
    assert_not_nil resp, "response was nil"
    assert_not_nil resp["error"], "error was #{resp["error"]}"
    assert resp["error"]== exception_class.to_s, " error was #{resp["error"]} but expected #{exception_class.to_s} "
    assert resp["message"] != nil , "response was excepted != nil, but was nil"

  end

  def should_contain_map_object(map_object_array, map_object)
    contains = false
    map_object_array.each do |t|
      if should_equal_map_object(t,map_object)
        contains = true
      end
    end
    assert contains
  end

  def should_contain_taxi(taxis_array, taxi)

    contains = false
    taxis_array.each do |t|
      if should_equal_taxi(t,taxi)
        contains = true
      end
    end
    assert contains
  end

  def should_contain_service(services, service)
    contains = false
    services.each do |t|
      if should_equal_service(t,service)
        contains = true
      end
    end
    assert contains, "#{services} does not contain service with id #{service.id}} and state #{service.get_state}"
  end

  def should_equal_taxi(taxi_as_json, taxi)
    taxi_as_json["id"] == taxi.id && taxi_as_json["installation_id"] == taxi.installation_id
  end

  def should_equal_service(service_as_json,service)
    service_as_json["id"]==service.id && service_as_json["address"]==service.address && service_as_json["verification_code"]==service.verification_code
  end

  def should_equal_map_object(map_object_json, map_object)

    map_object_json["id"] == map_object.id &&
        map_object_json["category"] == map_object.category &&
        map_object_json["latitude"] == map_object.latitude &&
        map_object_json["longitude"] == map_object.longitude
  end


end
