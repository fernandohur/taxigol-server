require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

	#
  test "if a service is created then the state must be pendiente" do
    s = Service.construct("abc","address")
    s.save
    assert s.is_pending, "state must be pendiente"

  end

  test "if a Service is created then the verification code and address must not be nil" do

    s = Service.construct("abc","address")
    s.save

    assert s.verification_code != nil
    assert s.address !=nil
    assert s.taxi == nil
    assert s.taxi_id == nil
    assert s.id != nil

  end

  test "if a Service is created then it can be canceled from :pendiente" do

    Taxi.delete_all
    Service.delete_all


    #Canceling from pendiente
    s = Service.construct("123","asd")
    s.save

    Service.update_cancel(s)

    assert s.is_canceled
    assert s.verification_code == "123"

  end

  test "if a Service is created then it can be canceled from :confirmado" do

    Taxi.delete_all
    Service.delete_all
    taxi = Taxi.get_or_create("taxi")

    ##canceling from confirmado
    s = Service.construct("123","asd")
    s.save

    Service.update_confirm(s,taxi.id)
    assert s.is_confirmed, "taxi state must be :confirmed "

    Service.update_cancel(s)
    assert s.is_canceled
    assert s.verification_code == "123"

  end

  test "if a Service is created then it can be canceled from :cumplido" do

    Taxi.delete_all
    Service.delete_all
    taxi = Taxi.get_or_create("taxi")

    ##canceling from confirmado
    s = Service.construct("123","asd")
    s.save

    Service.update_confirm(s,taxi.id)
    assert s.is_confirmed, "taxi state must be :confirmed "

    Service.update_cumplido(s,taxi.id,"123")
    assert s.is_complete

    begin
      Service.update_cancel(s)
      fail # fuck! I should not be here
      rescue Service::StateChangeError
      # all is ok :)
    end

  end

  test 'To complete Service then state must be :confirmado and verification code must match and taxi_id must match' do

    s = Service.construct("asd","asd")
    s.save

    begin
      Service.update_cumplido(s,1,"asd")
    rescue Service::StateChangeError
      assert s.taxi_id == nil
      assert s.address == "asd"
      assert s.is_pending
    end

  end

  test 'test new with pos should assign attrs correctly' do
    verification_code = '98'
    address = 'calle 132 a # 19-43'
    latitude = 12.89
    longitude = 12.23
    s = Service.construct(verification_code,address, latitude, longitude)
    s.save

    assert s.verification_code==verification_code
    assert s.address == address
    assert s.latitude == latitude
    assert s.longitude == longitude

    assert s.is_pending
    assert s.get_state==Service.pending

  end

  test 'construct Service with latitude,longitude & tip should assign attrs correctly' do
    verification_code = '98'
    address = 'calle 132 a # 19-43'
    latitude = 12.89
    longitude = 12.23
    tip = '50000'
    s = Service.construct(verification_code,address, latitude, longitude, tip)
    s.save

    assert s.verification_code==verification_code
    assert s.address == address
    assert s.latitude == latitude
    assert s.longitude == longitude
    assert s.tip == tip

    assert s.is_pending
    assert s.get_state==Service.pending

  end

  test ' get_pending_or_confirmed should return all services with state confirmed by taxi or pending' do

    #init services
    Service.delete_all

    s1 = Service.construct('12','address1',12.5,5.12)
    s2 = Service.construct('12','address1',12.5,5.12)
    s3 = Service.construct('12','address1',12.5,5.12)
    s4 = Service.construct('12','address1',12.5,5.12)
    s5 = Service.construct('12','address1',12.5,5.12)
    s6 = Service.construct('12','address2',12.5,23)
    s7 = Service.construct('12','asd',123,432)

    services = [s1,s2,s3,s4,s5,s6,s7]
    services.each do |s| s.save! end
    assert Service.all.size == 7

    #make 6 & 7 unavailable
    [s6,s7].each do |s|
      Service.update_confirm(s,-1)
    end
    Service.update_cumplido(s7,-1,'12')

    #init taxis
    Taxi.delete_all

    t1 = Taxi.get_or_create('1')
    t2 = Taxi.get_or_create('2')
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
