require 'test_helper'

class MapObjectsControllerTest < ActionController::TestCase
  setup do
    MapObject.delete_all
    assert_difference 'MapObject.all.size',5 do
      @map_objects = [MapObject.construct(MapObject.hueco, 1.101,3.2),
                      MapObject.construct(MapObject.hueco, 2.9,3.2),
                      MapObject.construct(MapObject.trancon, 3.8,3.2),
                      MapObject.construct(MapObject.trancon, 4.7,3.2),
                      MapObject.construct(MapObject.camara, 5.6,3.2)]
      @map_objects.each do |m|
        m.save
      end
    end
  end

  test "test setup" do
    assert MapObject.all.size == @map_objects.size
    assert MapObject.first.category==MapObject.hueco

  end

  test "index no params should return all map_objects" do

    get :index, {:format=>:json}
    resp = MultiJson.load(@response.body)
    @map_objects.each do |m|
      should_contain_map_object(resp,m)
    end

    assert resp.size == @map_objects.size, "resp size was #{resp.size} but @map_objects.size was #{@map_objects.size}"


  end

  test "index with params should return only by given category" do

    get :index, {:format=>:json, :category=>"hueco"}
    huecos = [@map_objects[0],@map_objects[1]]
    resp = MultiJson.load(@response.body)

    assert resp.size == 2
    huecos.each do |m|
      should_contain_map_object(resp,m)
    end

  end

  test "put to create with params creates a map_object" do

    put :create ,{:format=>:json, :category=>"hueco", :latitude=>-1.267, :longitude=>-1.3}
    resp = MultiJson.load(@response.body)

    assert should_equal_map_object(resp,MapObject.last)

    assert MapObject.last.category == "hueco"
    assert MapObject.last.latitude == -1.267

  end




end
