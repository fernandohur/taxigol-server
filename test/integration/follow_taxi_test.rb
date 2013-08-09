require 'test_helper'

#
# This class tests the correction of the following scenario
# 1. A driver logs in (therefore a taxi already exists)
# 2. A driver is moving around the city (therefore his position is updated)
# 3. A taxi is e-hailed (therefore a service is created)
# 4. The driver confirms the incoming service
# 5. The service's state is changed to confirmed
# 6. The driver attempts to get closer to the passenger
# 7. the last position is requested from the driver
class FollowTaxiTest < ActionDispatch::IntegrationTest

	setup do
		Position.delete_all
		Taxi.delete_all
		Driver.delete_all

    cedula = '10201020'
    celular = '3008734028'
    password = 'password'
    name = 'Billy Bob Turdington'
    extend ActionDispatch::TestProcess
    image = fixture_file_upload 'sample_file.png'

    driverHash = Hash.new
    driverHash['name'] =  name
    driverHash['cedula'] = cedula
    driverHash['image'] = image
    driverHash['cel_number'] = celular
    driverHash['password'] = password

    @driver = Driver.construct(driverHash, 'asd123')
		@driver.save!

	end

	test 'test scenario e-hail + confirm + get_latest' do

		#1. A driver logs in (therefore a taxi already exists)
		driver_json = driver_login(@driver.cedula, @driver.password)
		assert_equal driver_json['id'], @driver.id
		taxi_id = driver_json['taxi_id']

		# 2. A driver is moving around the city (therefore his position is updated)
		update_position(taxi_id)
		position_json = update_position(taxi_id)

		# there should be 2 positions
		assert_equal @driver.taxi.positions.size, 2
		latest_pos = get_latest_pos(taxi_id)

		# latest position should match
		assert_equal position_json, latest_pos

		# 3. A taxi is e-hailed (therefore a service is created)
		service_id = nil
		service_json = nil
		assert_difference 'Service.all.size',1 do
			service_json = hail_taxi('my crib, yo!' , '12')
			service_id = service_json['id']

			assert_not_nil service_json
			assert_not_nil service_id
		end

		service_state = nil
		# 4. The driver confirms the incoming service
		assert_no_difference 'Service.all.size' do
			service_updated = confirm_service(service_id, taxi_id)
			assert_equal service_updated['id'], service_json['id']
			service_state = service_updated['state']
		end

		# 5. The service's state is changed to confirmed
		assert_equal service_state, 'confirmado'

		# 6. The driver attempts to get closer to the passenger
		position = nil
		assert_difference 'Position.all.size', 2 do
			update_position(taxi_id)
			position = update_position(taxi_id)

		end

		latest_pos = get_latest_pos(taxi_id)

		assert_equal latest_pos, position


	end

	def get_latest_pos(taxi_id)
		get '/positions/get_last.json', :taxi_id=>taxi_id
		return res_as_json @response
	end

	# auths the driver
	def driver_login(username, password)
		post '/drivers/auth.json', :cedula =>username, :password => password
		return res_as_json @response
	end

	# updates the taxi's position with a random position. returns the newly created position
	def update_position(taxi_id)
		lat = rand*10
		lon = rand*10
		post '/positions.json', :latitude=>lat, :longitude=>lon,:taxi_id=>taxi_id
		return res_as_json @response
	end

	# hails a taxi
	def hail_taxi(address, verification_code)
		post '/services.json' , :address => address, :verification_code => verification_code, :latitude=> rand*10, :longitude => rand*10
		return res_as_json @response
	end

	def confirm_service(service_id, taxi_id)
		put "/services/#{service_id}.json", :taxi_id=>taxi_id, :state=>'confirmado'
		return res_as_json @response
	end

	# helper for DRYing up
	def res_as_json(resp)
		return MultiJson.load(resp.body)
	end

end
