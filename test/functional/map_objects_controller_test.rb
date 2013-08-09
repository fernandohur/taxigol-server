require 'test_helper'

class MapObjectsControllerTest < ActionController::TestCase
<<<<<<< HEAD
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
=======


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
>>>>>>> ceduquey
    end

  end

<<<<<<< HEAD
  test "put to create with params creates a map_object" do

    put :create ,{:format=>:json, :category=>"hueco", :latitude=>-1.267, :longitude=>-1.3}
    resp = MultiJson.load(@response.body)

    assert should_equal_map_object(resp,MapObject.last)

    assert MapObject.last.category == "hueco"
    assert MapObject.last.latitude == -1.267

  end


=======
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
>>>>>>> ceduquey


end
