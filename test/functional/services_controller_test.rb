require 'test_helper'

class ServicesControllerTest < ActionController::TestCase

  #=======================================
  # Helper methods go here
  #=======================================

  def should_match_service(service_json, service)
    assert_equal service_json["id"],service.id
    assert_equal service_json["taxi_id"], service.taxi_id
    assert_equal service_json["address"], service.address
    assert_equal service_json["verification_code"], service.verification_code
    assert_equal service_json["service_type"], service.service_type
  end

  # Creates a service with a random address and a random verification code
  # Use Service.last to access the created service
  def create_service
    assert_difference 'Service.all.size',1 do
      post :create, {:format=>:json, :address=>rand.to_s, :verification_code=>(rand*100).to_i.to_s, :service_type =>'normal', :user_id => 1, :latitude=>rand, :longitude=>rand}
    end
    return Service.last
  end

  # convenience method that creates a random service, confirms it and completes it
  def create_confirm_complete
    # Create a service
    service = create_service
    # Confirm it
    confirm_service service.id, @taxi.id
    # Complete it
    complete_service service.id, @taxi.id, service.verification_code  
    assert_completed service.id
    return service
  end

  # asserts that the service with the given id is confirmed
  def assert_confirmed(service_id)
    service = Service.find(service_id)
    assert service.is_confirmed, "expected #{Service.confirmed} but was #{service.get_state}"
  end

  # asserts that the service with the given id is confirmed
  def assert_pending(service_id)
    service = Service.find(service_id)
    assert service.is_pending, "expected #{Service.pending} but was #{service.get_state}"
  end

  # asserts that the service with the given id is completed
  def assert_completed(service_id)
    service = Service.find(service_id)
    assert service.is_complete, "expected #{Service.complete} but was #{service.get_state}"
  end

  # asserts that the service with the given id is cancelled
  def assert_cancelled(service_id)
    service = Service.find(service_id)
    assert service.is_canceled, "expected #{Service.cancelled} but was #{service.get_state}"
  end

  # marks a service as confirmed
  def confirm_service(service_id, taxi_id)
    assert_no_difference 'Service.all.size' do
      put :update, {:format=>:json, :id=>service_id, :state=>Service.confirmed, :taxi_id=>taxi_id}
    end
  end

  # marks a service as completed
  def complete_service(service_id, taxi_id, verification_code)
    assert_no_difference 'Service.all.size' do 
      put :update, {:format=>:json, :id=>service_id, 
        :state=>Service.complete, :taxi_id=>taxi_id, :verification_code=>verification_code} 
    end

  end

  # test setup method
  setup do

    Service.delete_all
    @service1 = Service.construct("12","calle 132 a # 19-43", "normal", 1)
    @service1.save
    @service2 = Service.construct("19","kra 132 a # 19-43", "aeropuerto", 2)
    @service2.save
    @service3 = Service.construct("88","calle 132BIS # 19-43", "normal", 1)
    @service3.save

    @taxi = Taxi.get_or_create("asd123")
    @pos = Position.new(:latitude=>123,:longitude=>456,:taxi_id=>@taxi.id)
    @pos.save

    @taxi2 = Taxi.get_or_create("qwe143")
    @pos2 =  Position.new(:latitude=>123,:longitude=>456,:taxi_id=>@taxi2.id)
    @pos2.save

  end

  #===================================
  # Test methods go here
  #===================================

  # Simple test to verify setup method
  test "verify setup" do
    assert Taxi.all.size == 2
    assert Taxi.first.positions.size == 1, "There must be 1 positions but there are #{Taxi.first.positions.size}"
    assert Service.get_by_state(Service.confirmed).size == 0
    assert_pending @service1.id
    assert_pending @service2.id
    assert_pending @service3.id
  end

  #
  # GIVEN a PUT request is sent to :update 
  # AND the state parameter is invalid (i.e. "blah")
  # THEN a state change error should be returned
  #
  test "changing state to invalid state should raise error" do

    put :update, {:format=>:json, :id=>@service1.id, :state=>"blah", :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)
  end

  #
  # GIVEN a new service
  # THEN it's state must be pending
  #
  test "initial state should be 'pending'" do
    # test for a newly created service
    @service = create_service
    assert_pending @service.id
    # test for existing service '@service1'
    assert_pending @service1.id
  end    

  #
  # GIVEN @service1 is pending
  # AND a PUT request is made to :update with :state=>Service.confirmed
  # THEN the service's state should be changed to confirmed
  #
  test "sending a PUT to :update with :state=>confirmed should confirm service" do

    confirm_service @service1.id, @taxi.id
    resp = MultiJson.load(@response.body)
    @service1 = @service1.reload
    should_match_service(resp, @service1)
    assert_confirmed @service1.id
  end

  #
  # GIVEN a newly created service
  # THEN the service can be confirmed ok
  # AND the service can be completed ok
  # AND the service's taxi_id must match that of the confirming taxi
  #
  test "confirm + complete service1" do

     service = create_service
     confirm_service service.id, @taxi.id
     assert_confirmed service.id

     complete_service service.id, @taxi.id, service.verification_code
     assert_completed service.id
     
  end

  #
  # GIVEN a completed service
  # AND an attempt is made to cancel it
  # THEN a StateChangeError should be launched 
  #
  test "confirm + complete + cancel should raise Service::StateChangeError" do

    create_confirm_complete

    # try to cancel it
    put :update, {:format=>:json, :id=>Service.last.id, :state=> Service.cancelled}
    should_contain_error_message(@response, Service::StateChangeError)

  end


  test "confirm + complete + abandon should raise Service::StateChangeError" do

    create_confirm_complete

    # attempt to abandon
    put :update, {:format=>:json, :id=>Service.last.id, :state=> Service.abandoned, :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "confirm + complete + pending should raise Service::StateChangeError" do

    create_confirm_complete

    # attempt to set pending
    put :update, {:format=>:json, :id=>Service.last.id, :state=> Service.pending, :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "confirm + cancel should cancel" do

    @service = create_service
    confirm_service @service.id, @taxi.id 
    put :update, {:format=>:json, :id=>@service.id, :state=>Service.cancelled}
    assert_cancelled @service.id
  end

  test "create + cancel should cancel" do

    @service = create_service
    put :update, {:format=>:json, :id=>@service.id, :state=>Service.cancelled}
    assert_cancelled @service.id

  end

  test "create + abandon should raise Service::StateChangeError" do

    @service = create_service
    put :update, {:format=>:json, :id=>@service.id, :state=>Service.abandoned, :taxi_id=>@taxi.id}

    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "create + confirm + abandon should abandon" do

    @service = create_service
    confirm_service @service.id, @taxi.id
    put :update, {:format=>:json, :id=>@service.id, :state=>Service.abandoned, :taxi_id=>0}

    should_contain_error_message(@response, Service::StateChangeError)

    put :update, {:format=>:json, :id=>@service.id, :state=>Service.abandoned, :taxi_id=>@taxi.id}
    assert Service.last.is_abandoned

    put :update, {:format=>:json, :id=>@service.id, :state=>Service.abandoned, :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)
  end

  test "post to create with latitude and longitude should init those attrs" do
    address = 'calle 132 a # 19-43'
    verification_code = '12'
    service_type = 'normal'
    user_id = 1
    latitude = 12.32
    longitude = 13.45
    assert_difference 'Service.all.size',1 do
      post :create, {:format=>:json, :address=>address, :verification_code=>verification_code, :service_type=>service_type, :user_id => user_id, :latitude=>latitude,:longitude=>longitude}
    end
    s = Service.last
    assert s.address == address
    assert s.verification_code == verification_code
    assert s.service_type == service_type
    assert s.user_id == user_id
    assert s.latitude == latitude
    assert s.longitude == longitude
  end

  test 'post with no lat should not init lat nor lon' do
    address = 'calle 132 a # 19-43'
    verification_code = '12'
    service_type = 'aeropuerto'
    assert_difference 'Service.all.size',1 do
      post :create, {:format=>:json, :address=>address, :verification_code=>verification_code, :service_type=>service_type}
    end
    s = Service.last
    assert s.address == address
    assert s.verification_code == verification_code
    assert s.service_type == service_type
    assert s.longitude == nil, "longitude shold be nil but was #{s.longitude}"
    assert s.latitude == nil
    assert_equal s.tip, ''
  end

  test 'post to create should init all vars' do
  	address = 'calle 132 a # 19-43'
  	verification_code = '12'
    service_type = 'normal'
    user_id = 1
  	latitude = 12.995
  	longitude = -92.352
  	tip = '50.000'
  	post :create, {
  		:format => :json,
  		:address => address,
  		:verification_code => verification_code,
      :service_type => service_type,
      :user_id => user_id,
  		:latitude => latitude,
  		:longitude => longitude,
  		:tip => tip }

  	s = Service.last
  	json = MultiJson.load(@response.body)
  	should_match_service(json,s)
  	assert_not_nil json['tip']
  	assert_equal tip, json['tip']
  end

  # GIVEN there is a service with id=X
  # AND a GET is sent to services/:id.json
  # THEN the corresponding json string encoding that service should be returned
  test "sending a GET to :show should return a json string that matches the correct Service" do
    get :show , {:format=>:json,:id=>@service2.id}
    service = MultiJson.load(@response.body)
    should_match_service(service, @service2)

    get :show , {:format=>:json,:id=>@service1.id}
    service = MultiJson.load(@response.body)
    should_match_service(service, @service1)

    get :show , {:format=>:json,:id=>@service3.id}
    service = MultiJson.load(@response.body)
    should_match_service(service, @service3)
  end



end
























