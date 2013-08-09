require 'test_helper'

class MapObjectTest < ActiveSupport::TestCase
<<<<<<< HEAD
  # test "the truth" do
  #   assert true
  # end


  test "construct should set getters " do
    
    mo = MapObject.construct(MapObject.hueco, 123, 234)
    assert mo.class == MapObject
    assert mo.category == MapObject.hueco
    assert mo.latitude == 123
    assert mo.longitude == 234

  end

  test "get all by category" do

    @m1 = MapObject.construct(MapObject.hueco, 123,234)
    @m2 = MapObject.construct(MapObject.trancon, 123,345)
    @m3 = MapObject.construct(MapObject.hueco,12,7.2)
    @m4 = MapObject.construct(MapObject.camara, 1.07, -74.06)

    @m1.save
    @m2.save
    @m3.save
    @m4.save

    huecos = MapObject.get_by_category(MapObject.hueco)
    assert huecos.size == 2

    trancones = MapObject.get_by_category(MapObject.trancon)
    assert trancones.size == 1

    camaras = MapObject.get_by_category(MapObject.camara)
    assert camaras.size == 1
=======


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
>>>>>>> ceduquey

  end



end
<<<<<<< HEAD
=======
















>>>>>>> ceduquey
