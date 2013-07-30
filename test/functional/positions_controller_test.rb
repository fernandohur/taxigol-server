require 'test_helper'

class PositionsControllerTest < ActionController::TestCase

  setup do
    @taxi = Taxi.get_or_create('123')
    @pos1 = Position.new(:latitude=>rand*100,:longitude=>rand*100,:taxi_id=>@taxi.id)
    @pos2 = Position.new(:latitude=>rand*100,:longitude=>rand*100,:taxi_id=>@taxi.id)
    @pos3 = Position.new(:latitude=>rand*100,:longitude=>rand*100,:taxi_id=>@taxi.id)
    @pos1.save
    @pos2.save
    @pos3.save

    @taxi2 = Taxi.get_or_create('24')
    @taxi2.positions.delete_all
    @taxi2.save

  end

  #
  # This is a simple test to verify the test setup
  #
  test "verify setup" do
    assert @taxi2.positions.size == 0
    assert @taxi.positions.size == 3
  end

  #
  # GIVEN a GET request is sent to :index
  # THEN a list of all the positions should be returned
  #
  test "get to index should return all positions" do

    get :index , {:format => :json}
    assert_response :success

    resp = MultiJson.load(@response.body)
    assert resp.size == Position.all.size
  end

  #
  # GIVEN a POST request to :create is sent with latitude, longitude and taxi_id
  # THEN the response should be :success
  # AND the response body should contain a position object as a json
  # AND the json should match @taxi.positions.last
  # AND the json should match @taxi.get_last_position
  #
  test "create should increment positions and return the position" do

    assert_difference 'Position.all.size',1 do
      post :create, {:format => :json, :latitude=>rand*100, :longitude=>rand*100, :taxi_id => @taxi.id}
      assert_response :success
      resp = MultiJson.load(@response.body)
      assert_json_matches_position(resp, @taxi.positions.last)
      assert_json_matches_position(resp, @taxi.get_last_position)
    end
  end

  #
  # GIVEN a GET request is sent to :get_last 
  # AND the taxi has at least one position
  # THEN the latest position should be returned
  #
  test "get to :get_last given that taxi has positions should return last position" do

    get :get_last, {:format=>:json,:taxi_id=>@taxi.id}
    resp = MultiJson.load(@response.body)
    assert_json_matches_position(resp, @taxi.get_last_position)
    assert_json_matches_position(resp, @pos3)
    assert_json_not_matches_position(resp, @pos1)
    assert_json_not_matches_position(resp, @pos2)
  end

  #
  # GIVEN a GET request is sent to :get_last 
  # AND the taxi has only 1 position
  # THEN that position should be returned
  #
  test "get to :get_last given only one position should return that position" do

    temp_position = Position.new(:latitude=>rand*100,:longitude=>rand*100,:taxi_id=>@taxi2.id)
    temp_position.save!
    @taxi2.reload
    
    get :get_last, {:format => :json, :taxi_id => @taxi2.id}
    assert_response :success
    resp = MultiJson.load(@response.body)
    assert_json_matches_position resp, temp_position
    assert_json_matches_position resp, @taxi2.get_last_position
    assert_json_matches_position resp, @taxi2.positions.last

  end

  #
  # GIVEN a GET request is sent to :get_last
  # AND the taxi has no positions
  # THEN a NoPositionError should be raised
  #
  test "get to :get_last given that taxi has no positions should raise NoPositionError" do

    get :get_last, {:format=>:json,:taxi_id=>@taxi2.id}
    should_contain_error_message(@response, NoPositionError)
  end
end
