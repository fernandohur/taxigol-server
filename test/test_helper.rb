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
    assert_not_nil resp["message"], "message should not be nil, but was nil"

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

  #
  # asserts that a json string representation of a position matches
  # a position's values. This method checks that id, taxi_id, latitude, longitude
  # match. If at least one field does not match, an assertion error will be raised
  # @resp a json string with the following structure
  #
  # {
  #   "id":(id num),
  #  "taxi_id":(taxi id as a number),
  #   "latitude":(num),
  #   "longitude":(num)
  # }
  # @pos a Position object
  # @return void
  def assert_json_matches_position(resp, pos)
    assert_equal resp['id'], pos.id 
    assert_equal resp['taxi_id'], pos.taxi_id
    assert_equal resp['latitude'], pos.latitude
    assert_equal resp['longitude'], pos.longitude
  end

  # Similar to assert_json_matches_position, this method
  # asserts that the given json string does NOT match the Position
  # object 
  def assert_json_not_matches_position(resp, pos)
    id_match = resp['id'] == pos.id 
    taxi_id_match = resp['taxi_id'] == pos.taxi_id
    lat_match = resp['latitude'] == pos.latitude
    lon_match = resp['longitude'] == pos.longitude
    assert !id_match || !taxi_id_match || !lat_match || !lon_match
  end

  def sample_file(filename = "sample_file.png")
    File.new("test/fixtures/#{filename}")
  end

  def rand_int(max=50)
    return (1+rand*max).to_i
  end

  # compares two models and asserts that all of their attr_accesible 
  # match using assert_equal
  def assert_models_match(model1, model2)
    clazz = model1.class
    attributes = clazz.attr_accessible[:default]
    
    attributes.each do |attribute|
      if attribute.size > 0
        assert_equal model1.send(attribute),model2.send(attribute), 
        "#{model1} compared to #{model2} but failed"
      end 
    end
  end


  def assert_model_matches_json(model,json,attributes)
    keys = attributes.keys
    keys.each do |key|
      assert_equal model.send(key),json.send("[]",key), 
      "comparing #{model} and #{json} did not match at #{model.send(key)} vs #{json.send("[]",key)}" 
    end
  end

end
