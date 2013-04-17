require 'test_helper'

class MapObjectTest < ActiveSupport::TestCase
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

  end



end
