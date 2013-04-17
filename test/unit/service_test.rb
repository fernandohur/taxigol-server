require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

  test "if a Service is created then the state must be pendiente" do

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
    taxi = Taxi.auth("taxi")

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
    taxi = Taxi.auth("taxi")

    ##canceling from confirmado
    s = Service.construct("123","asd")
    s.save

    Service.update_confirm(s,taxi.id)
    assert s.is_confirmed, "taxi state must be :confirmed "

    Service.update_cumplido(s,taxi.id,"123")
    assert s.is_complete

    Service.update_cancel(s)
    assert s.is_canceled
    assert s.verification_code == "123"

  end

  test "To complete Service then state must be :confirmado and verification code must match and taxi_id must match" do

    s = Service.construct("asd","asd")
    s.save

    begin
      Service.update_cumplido(s,1,"asd")
    rescue StateChangeError => e
      assert s.taxi_id == nil
      assert s.address == "asd"
      assert s.is_pending
    end

  end

  test "test helper methods" do

    s = Service.construct("a","b")
    s.save

    assert s.is_pending
    assert s.get_state==Service.pending

  end


end
