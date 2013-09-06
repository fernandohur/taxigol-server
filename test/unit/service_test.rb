require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

   #
  # Helper methods
  #

  def assert_confirmed(service)
    assert service.is_confirmed, "service #{service.id} should have been confirmed, but was #{service.state}"
    assert_equal service.get_state, Service.confirmed
  end

  def assert_complete(service)
    assert service.is_complete, "service #{service.id} should have been complete, but was #{service.state}"
    assert_equal service.get_state, Service.complete
  end

  def assert_pending(service)
    assert service.is_pending, "service #{service.id} should have been pending, but was #{service.state}"
    assert_equal service.get_state, Service.pending 
  end

  def assert_cancelled(service)
    assert service.is_canceled, "service #{service.id} should have been canceled, but was #{service.state}"
    assert_equal service.get_state, Service.cancelled
  end

  def create_service()
    address = "address"+rand.to_s
    verification_code = (100*rand).to_i.to_s
    service_type = "normal"
    user_id = 1
    latitude = rand
    longitude = rand
    tip = rand.to_s
    service = Service.construct(verification_code,address, service_type, user_id, latitude, longitude, tip)
    
    assert_pending service
    assert_equal service.address, address
    assert_equal service.verification_code, verification_code
    assert_equal service.service_type, service_type
    assert_equal service.user_id, user_id
    assert_equal service.latitude,latitude
    assert_equal service.longitude,longitude
    assert_equal service.tip,tip

    return service    
  end

  def create_service_confirmed(taxi_id)
    service = create_service()
    assert_pending(service)

    Service.update_confirm(service, taxi_id)
    service.save!
    return service
  end

  def create_service_complete(taxi_id)
    service = create_service_confirmed taxi_id
    assert_confirmed service

    Service.update_cumplido(service, taxi_id, service.verification_code)
    service.save!
    return service
  end

  #=========================0
  # Test methods go here
  #=========================0

	# GIVEN a new service is created
  # THEN it's state must be pending
  test "if a service is created then the state must be pendiente" do
    s = create_service
    s.save
    assert_pending s
  end

  # GIVEN a service s is created
  # THEN verification_code, address, taxi, taxi_id and id must not be nil
  test "if a Service is created then the verification code and address must not be nil" do

    s = create_service
    s.save

    assert s.verification_code != nil
    assert s.address !=nil
    assert s.service_type != nil
    assert s.user_id != nil
    assert s.taxi == nil
    assert s.taxi_id == nil
    assert s.id != nil

  end

  # GIVEN a service is created
  # AND an attempt is made to cancel it
  # THEN the service's state must be cancelled
  test "a service can be cancelled if it is pending" do

    #Canceling from pendiente
    s = create_service
    s.save
    Service.update_cancel(s)

    assert_cancelled s
  end

  # GIVEN a service is created
  # AND the state is confirmado
  # THEN it can be cancelled
  test "a service can be canceled if it is confirmed" do

    taxi = Taxi.get_or_create("ASd321")

    ##canceling from confirmado
    s = create_service_confirmed(taxi.id)
    assert_confirmed s

    Service.update_cancel(s)
    assert s.is_canceled
  end

  test "a service can NOT be canceled if it is completed" do

    taxi = Taxi.get_or_create("ASd321")

    #canceling from confirmado
    s = create_service_complete(taxi.id)

    begin
      Service.update_cancel(s)
      fail # fuck! I should not be here
      rescue Service::StateChangeError
      # all is ok :)
    end

  end

  test 'a service cannot be completed if it is pending' do
    
    taxi = Taxi.get_or_create("ASd321")

    s = create_service
    begin 
      Service.update_cumplido s, taxi.id, s.verification_code 
    rescue Service::StateChangeError
      assert_pending s
    end
  end

  test 'a service cannot be abandoned if it is pending' do
    
    taxi = Taxi.get_or_create("ASd321")

    s = create_service
    begin 
      Service.update_abandon s, taxi.id
    rescue Service::StateChangeError
      assert_pending s
    end
  end

  test 'To complete Service then state must be :confirmado and verification code must match and taxi_id must match' do

    s = Service.construct("asd","asd", "normal", 1)
    s.save

    begin
      Service.update_cumplido(s,1,"asd")
    rescue Service::StateChangeError
      assert s.taxi_id == nil
      assert s.address == "asd"
      assert s.is_pending
    end

  end

  # this method tests that the constructor effectively
  # assigns correct values
  test 'test new with pos should assign attrs correctly' do
    verification_code = '98'
    address = 'calle 132 a # 19-43'
    service_type = "normal"
    user_id = 1
    latitude = 12.89
    longitude = 12.23
    s = Service.construct(verification_code,address, service_type, user_id, latitude, longitude)
    s.save

    assert s.verification_code==verification_code
    assert s.address == address
    assert s.service_type == service_type
    assert s.user_id == user_id
    assert s.latitude == latitude
    assert s.longitude == longitude
    assert_equal s.tip,''
    assert_pending s

  end

  test 'construct Service with latitude,longitude & tip should assign attrs correctly' do
    verification_code = '98'
    address = 'calle 132 a # 19-43'
    service_type = "normal"
    user_id = 1
    latitude = 12.89
    longitude = 12.23
    tip = '50000'
    s = Service.construct(verification_code,address, service_type, user_id, latitude, longitude, tip)
    s.save

    assert s.verification_code==verification_code
    assert s.address == address
    assert s.service_type == service_type
    assert s.user_id = user_id
    assert s.latitude == latitude
    assert s.longitude == longitude
    assert s.tip == tip

    assert s.is_pending
    assert s.get_state==Service.pending

  end

  test ' get_pending_or_confirmed should return all services with state confirmed by taxi or pending' do

    s1 = Service.construct('12','address1','normal',1, 12.5,5.12)
    s2 = Service.construct('12','address1','normal',2, 12.5,5.12)
    s3 = Service.construct('12','address1','normal',1, 12.5,5.12)
    s4 = Service.construct('12','address1','normal',3, 12.5,5.12)
    s5 = Service.construct('12','address1','normal',1, 12.5,5.12)
    s6 = Service.construct('12','address2','normal',3, 12.5,23)
    s7 = Service.construct('12','asd','normal',2, 123,432)

    services = [s1,s2,s3,s4,s5,s6,s7]
    services.each do |s| s.save! end
    assert Service.all.size == 7

    #make 6 & 7 unavailable
    [s6,s7].each do |s|
      Service.update_confirm(s,-1)
    end
    Service.update_cumplido(s7,-1,'12')

    t1 = Taxi.get_or_create("ASd321")
    t2 = Taxi.get_or_create("ASD222")
    taxis = [t1,t2]
    taxis.each do |t| t.save! end

    assert Taxi.all.size == 2

    #confirm services 1 & 2
    Service.update_confirm(s1,t1.id)
    Service.update_confirm(s2,t2.id)

    #Now, fo' the test! yeah!
    #first lets test for Taxi s1
    temp_services = Service.get_pending_or_confirmed(t1.id)
    [s1,s3,s4,s5].each do |s|
      assert temp_services.include? s
    end

    #ok, now lots test for Taxi s2
    temp_services = Service.get_pending_or_confirmed(t2.id)
    [s2,s3,s4,s5].each do |s|
      assert temp_services.include? s
    end
  end


end
