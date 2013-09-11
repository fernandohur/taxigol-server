require 'test_helper'

class PositionTest < ActiveSupport::TestCase

	test "create_random_position should create a position" do
		num_created = 5
		assert_difference 'Position.all.size',num_created do
			num_created.times do
				create_random_position
			end
		end
	end

	def create_random_position
		Position.create({:latitude=>rand*100,:longitude=>rand*100,user_id=>rand})
	end

	test "initialize position should set params" do

		position = Position.new(:latitude=>12, :longitude=>0.0034,:taxi_id=>12)
		position.save;

		position = Position.last;

		assert position.latitude == 12
		assert position.longitude == 0.0034
		assert position.taxi_id == 12

	end




end
