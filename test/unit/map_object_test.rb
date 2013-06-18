require 'test_helper'

class MapObjectTest < ActiveSupport::TestCase


  test 'create method should set the correct arguments' do

    category = MapObject::Categories::GAS_STATION
    latitude = 96.0
    longitude = 12.97
    expire_in_seconds = 5000
    map_object = MapObject.construct(category, latitude, longitude, expire_in_seconds)
    map_object.save!

    assert map_object.category == category
    assert map_object.latitude == latitude
    assert map_object.longitude == longitude
    assert_not_nil map_object.id
    assert_not_nil MapObject.find(map_object.id)

  end

  test 'cannot expire an unexpired map_object' do

    map_object = MapObject.construct(MapObject::Categories::GAS_STATION,123,345,5000)
    map_object.save!

    assert_raises MapObject::ExpireError do
      map_object.expire
    end

    assert_not_nil MapObject.find(map_object.id)

  end

  test 'expire an unexpirable map_object should raise error' do

    map_object = MapObject.construct(MapObject::Categories::GAS_STATION,123,345)
    map_object.save!

    assert_raises MapObject::ExpireError do
      map_object.expire
    end

    assert_not_nil MapObject.find(map_object.id)

  end

  test 'expire an expired map_object should remove it from db' do

    map_object = MapObject.construct(MapObject::Categories::GAS_STATION, 12,23,1)
    map_object.save

    sleep(2.seconds)
    assert_not_nil MapObject.find(map_object.id)

    map_object.expire

    assert_raises ActiveRecord::RecordNotFound do
      MapObject.find(map_object.id)
    end

  end



end
















