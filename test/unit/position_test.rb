require 'test_helper'

class PositionTest < ActiveSupport::TestCase

  test "initialize position should set params" do

    position = Position.new(:latitude=>12, :longitude=>0.0034,:taxi_id=>12)
    position.save;

    position = Position.last;

    assert position.latitude == 12
    assert position.longitude == 0.0034
    assert position.taxi_id == 12

  end

end
