require 'test_helper'

class MapObjectsControllerTest < ActionController::TestCase


  setup do

    @m0 = MapObject.construct(MapObject::Categories::TRAFFIC_FAST,23,45,1)
    @m1 = MapObject.construct(MapObject::Categories::ACCIDENT,12.0,23.075,60)
    @m2 = MapObject.construct(MapObject::Categories::ACCIDENT,12.0,23.075)
    @m3 = MapObject.construct(MapObject::Categories::GAS_STATION,12.0,23.075,5)
    @m4 = MapObject.construct(MapObject::Categories::POLICE,12.0,23.075,60)
    [@m0, @m1, @m2, @m3, @m4].each do |m|
      m.save!
    end

  end

  test 'test setup' do
    sleep 1
    assert_equal 5, MapObject.all.size
    assert MapObject.first.is_expired?
    assert !MapObject.last.is_expired?

  end

  test 'POST to :create should create a map_object in db' do

    category = MapObject::Categories::TRAFFIC_FAST
    latitude = 12.0
    longitude = 23.1
    expire_in = 12

    assert_difference 'MapObject.all.size', 1 do
      post :create, {:format=>:json, :category=>category, :latitude=>latitude, :longitude=>longitude, :expire_in=>expire_in}
    end

    json = MultiJson.load(@response.body)

    assert should_equal_map_object(json, MapObject.last)

  end

  test 'GET to :index should return all map_objects that have not expired' do

    assert_no_difference 'MapObject.all.size' do
      sleep(1)
      get :index, {:format=>:json}

      json = MultiJson.load(@response.body)
      assert_equal json.size, 4
    end

  end

  test 'GET to :index with param category should return only objects in specific category' do
    sleep 1
    assert_no_difference 'MapObject.all.size' do

      get :index, {:format=>:json, :category=>MapObject::Categories::GAS_STATION}
      json = MultiJson.load(@response.body)
      assert_equal json.size, 1

      get :index, {:format=>:json, :category=>MapObject::Categories::ACCIDENT}
      json = MultiJson.load(@response.body)
      assert_equal json.size, 2

      get :index, {:format=>:json, :category=>MapObject::Categories::TRAFFIC_FAST}
      json = MultiJson.load(@response.body)
      assert_equal json.size, 0

    end

  end

  test 'POST to :reset should eliminate all map_objects' do

    assert_difference 'MapObject.all.size', -MapObject.all.size do
      post :reset , {:format=>:json}
    end

    assert_equal MapObject.all.size, 0

  end

  test 'POST to :expire with expired map_object should remove it from db' do

    id = @m0.id

    sleep 1
    assert_difference 'MapObject.all.size', -1 do
      post :expire, {:format=>:json, :id=>id}
    end
    assert_raises ActiveRecord::RecordNotFound do
      MapObject.find(id)
    end

  end

  test 'POST to :expire with unexpirable map_object should return message' do

    id = @m1.id

    assert_no_difference 'MapObject.all.size' do
      post :expire, {:format=>:json, :id=>id}
    end

    assert @response.body.include? MapObject::ExpireError.to_s

  end


end
