require 'test_helper'

class PanicTest < ActiveSupport::TestCase


<<<<<<< HEAD
  test "creating a panic with no taxi launches error" do

    Taxi.delete_all
    no_taxi = false
    Panic.delete_all

    assert Panic.all.size == 0, "there must be no Panics but"

    begin
      Panic.construct(1)
      assert false
    rescue NoTaxiError
      no_taxi = true
    end
    assert no_taxi
    assert Panic.all.size == 0, "there must be no Panics but"
  end

  test "creating a panic with existing taxi but no location launches error" do

    Taxi.delete_all
    taxi = Taxi.auth("123")
    no_pos = false
    Panic.delete_all

    begin
      Panic.construct(taxi.id)
      assert false
    rescue NoPositionError
      no_pos = true
    end
    assert no_pos
    assert Panic.all.size == 0, "there must be no Panics"

  end

  test "creating a panic with taxi with position must be successful" do

    Panic.delete_all
    taxi = Taxi.auth("123")
    pos = Position.new(:taxi_id=>taxi.id, :latitude=>123, :longitude=>234)
    taxi.save
    pos.save

    assert taxi.positions.first.id == pos.id, "positions must be equal"

    panic = Panic.construct(taxi.id)
    panic.save

    assert Panic.all.size == 1, "there must be exactly one Panic but there are #{Panic.all.size}"
    assert panic.position_id == pos.id, "positions must match"
    assert panic.position.id = pos.id, "positions must match"

  end

  test " if there is a panic in the DB his position cannot be nil " do
    Panic.delete_all
    taxi = Taxi.auth("123")
    pos = Position.new(:taxi_id=>taxi.id, :latitude=>123, :longitude=>234)
    taxi.save
    pos.save

    assert taxi.positions.first.id == pos.id, "positions must be equal"

    panic = Panic.construct(taxi.id)
    panic.save

    assert panic.get_taxi.id == taxi.id, "taxis must match"

  end



end
=======
	test "calling contruct should set correct params" do
	
		latitude = 96.5
		longitude = 23.4
		taxi_id = 5
		panic = Panic.construct(latitude, longitude, taxi_id)
		panic.save!

		assert_equal panic.latitude, latitude
		assert_equal panic.longitude, longitude
		assert_equal panic.taxi_id, taxi_id

	end

end
>>>>>>> ceduquey
