require 'test_helper'

class MapObjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "construct should set getters " do
    
    mo = MapObject.construct(MapObject.hueco, 123, 234)

    assert mo.category == MapObject.hueco
    assert mo.latitude == 123
    assert mo.longitude == 234

  end

end
