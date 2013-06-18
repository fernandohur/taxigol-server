require 'test_helper'

class PositionsControllerTest < ActionController::TestCase

  setup do
    @taxi = Taxi.get_or_create('123')
    @pos1 = Position.new(:latitude=>12,:longitude=>234.09,:taxi_id=>@taxi.id);
    @pos2 = Position.new(:latitude=>12,:longitude=>234.09,:taxi_id=>@taxi.id);
    @pos3 = Position.new(:latitude=>12,:longitude=>234.09,:taxi_id=>@taxi.id);
    @pos1.save
    @pos2.save
    @pos3.save

    @taxi2 = Taxi.get_or_create('24')
    @taxi2.positions.delete_all
    @taxi2.save

  end

  test "verify setup" do
    assert @taxi2.positions.size == 0
    assert @taxi.positions.size == 3
  end

  test "get to index should return all positions" do

    get :index , {:format => :json}
    assert_response :success

    resp = MultiJson.load(@response.body)
    assert resp.size == Position.all.size

  end

  test " create should increment positions and return the position " do

    assert_difference 'Position.all.size',1 do
      post :create, {:format => :json, :latitude=>19, :longitude=>0.067, :taxi_id => @taxi.id}
      assert_response :success

      resp = MultiJson.load(@response.body)
      assert_json_matches_position(resp, @taxi.positions.last)
    end

  end

  test " get to :get_last given that taxi has positions should return last position" do

    get :get_last, {:format=>:json,:taxi_id=>@taxi.id}
    resp = MultiJson.load(@response.body)
    assert_json_matches_position(resp, @taxi.get_last_position)


  end

  test "get to :get_last given that taxi has no positions should raise NoPositionError" do

    get :get_last, {:format=>:json,:taxi_id=>@taxi2.id}
    should_contain_error_message(@response, NoPositionError)

  end

end
