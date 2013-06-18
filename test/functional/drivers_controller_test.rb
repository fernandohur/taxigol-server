require 'test_helper'

class DriversControllerTest < ActionController::TestCase

  ##
  #  in this config there are three drivers and 2 taxis. Drivers 2 and 3 share the same taxi
  ##
  setup do

    Driver.delete_all
    Taxi.delete_all

    @driver1 = Driver.construct('robert', '1020761351', 'mypass123','ABC123')
    @driver2 = Driver.construct('paul', '123987234', 'mypass987', 'ABC234')
    @driver3 = Driver.construct('paul', '1029375', 'pas123', 'ABC234')

    [@driver1, @driver2, @driver3].each do |d| d.save! end

  end

  test 'test setup' do
    assert Driver.all.size == 3
    assert Taxi.all.size == 2 , "instead there are #{Taxi.all.size} taxis"
    assert Taxi.get_drivers(@driver2.taxi_id).include? @driver2
    assert Taxi.get_drivers(@driver2.taxi_id).include? @driver3
  end

  test 'creating a driver should increase driver count and result should be a driver' do

    cedula = '102020394875'
    password = 'mypwd'
    name = 'richard the third'
    placa = 'ABC987'

    assert_difference 'Driver.all.size',1 do
      post :create, {:format=>:json, :cedula=>cedula, :password=>password, :name=>name, :placa=>placa}
      resp = @response.body
      json = MultiJson.load(resp)
      assert_json_matches_driver(json, Driver.last)
    end

  end

  test ' test auth with correct creds' do

    post :auth , {:format=>:json , :cedula=>@driver1.cedula, :password=>@driver1.password}
    resp = @response.body
    json = MultiJson.load(resp)
    assert_json_matches_driver(json, @driver1)

  end

  test ' test auth with wrong creds' do

    post :auth , {:format=>:json , :cedula=>@driver1.cedula.to_s<<'_', :password=>@driver1.password}
    resp = @response.body
    json = MultiJson.load(resp)
    assert json['message']!=nil
    assert (resp.match /{"message":".+"}/)[0]==resp

  end

  test ' reset should delete all drivers' do

    assert Driver.all.size > 0

    post :reset ,{:format=>:json}
    assert Driver.all.size == 0

  end



   def assert_json_matches_driver(json, driver)

     assert_equal json['cedula'],driver.cedula
     assert_equal json['name'],driver.name
     assert_equal json['password'],driver.password
     assert_equal json['taxi_id'], driver.taxi_id
   end

   test ' test get drivers from a taxi' do

     get :get_drivers , {:format=>:json, :taxi_id=>@driver1.taxi_id}
     resp = @response.body
     json = MultiJson.load(resp)

     assert json.size == 1
     assert_json_matches_driver(json[0], @driver1)

     get :get_drivers , {:format=>:json, :taxi_id=>@driver2.taxi_id}
     resp = @response.body
     json = MultiJson.load(resp)

     assert json.size == 2



   end


end






















