require 'test_helper'

class ApidUserTest < ActiveSupport::TestCase

	def get_apid_user_hash(user_id, device, value)
		return {:user_id=>user_id, :device=>device,:value=>value}
	end

	def get_random_apid_user_hash(user_id)
		return get_apid_user_hash(user_id, rand.to_s, rand.to_s)
	end

	test "get_or_create will create a new ApidUser object if there is not one already" do
		#given no apids
		ApidUser.delete_all

		#then
		assert_difference 'ApidUser.where("").size',1 do
			hash = get_random_apid_user_hash(rand_int(1000))
			apid = ApidUser.create_or_update(hash)
			assert_model_matches_json(apid,hash)
		end
	end

	test "get_or_create will remove all existing ApidUser objects if there are any
		and will create a new one" do
		ApidUser.delete_all
		user_id = 1
		assert_difference 'ApidUser.where("").size',1 do
			ApidUser.create_or_update get_random_apid_user_hash(user_id)
			ApidUser.create_or_update get_random_apid_user_hash(user_id)
		end
		assert_equal 1,ApidUser.where(user_id: user_id).size
	end

end
