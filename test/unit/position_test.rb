require 'test_helper'

class PositionTest < ActiveSupport::TestCase

	#========================================
	# Helper methods go here
	#========================================

	# Helper method that constructs a hash with the given parameters
	# For example get_position_hash(a,b,c) would return
	# {
	# 	:latitude=>a,
	# 	:longitude>b,
	# 	:taxi_id=>c
	# }
	def get_position_hash(latitude,longitude,taxi_id)
		return {:latitude=>latitude,:longitude=>longitude,:taxi_id=>taxi_id}
	end

	# using {@link get_position_hash} returns a randomly created hash
	def get_random_position_hash
		return get_position_hash(rand*100,rand*100,rand_int(10000))
	end

	# using {@link get_random_position} creates a new Position object
	# using Position.create
	def create_random_position
		Position.create get_random_position_hash
	end

	
	def assert_hash_equals_position(hash,position)
		assert_equal hash[:latitude],position.latitude
		assert_equal hash[:longitude],position.longitude
		assert_equal hash[:taxi_id],position.taxi_id
	end

	def assert_positions_match(position1,position2)
		assert_models_match(position1,position2)
	end

	#========================================
	# Tests go here
	#========================================

	test "create_random_position should create a position" do
		num_created = 5
		assert_difference 'Position.all.size',num_created do
			num_created.times do
				hash = get_random_position_hash
				Position.create(hash)
				assert_hash_equals_position(hash,Position.last)
			end
		end
	end

	test "find_last should return the last position" do 
		
		last_positions = {}
		#given
		rand_int.times do
			rand_int.times do |i|
				hash = get_position_hash(rand,rand,i)
				last_positions[i] = Position.create(hash)
			end
		end

		last_positions.keys.each do |k|
			pos = last_positions[k]
			assert_positions_match(pos, Position.find_last(k))
		end

		position = Position.create(get_position_hash(rand,rand,1))
		assert_positions_match position, Position.find_last(1)
	end

	test "remove old positions " do
		#give
		rand_int.times do
			rand_int.times do |i|
				hash = get_position_hash(rand,rand,i)
				Position.create(hash)
			end
		end
	end

end
