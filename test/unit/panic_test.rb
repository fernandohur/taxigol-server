require 'test_helper'

class PanicTest < ActiveSupport::TestCase


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