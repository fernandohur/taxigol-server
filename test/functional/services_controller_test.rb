require 'test_helper'

class ServicesControllerTest < ActionController::TestCase

  def should_match_service(service_json, service)
    service_json["id"]==service.id && service_json["taxi_id"]==service.taxi_id && service_json["address"] == service.address
  end

  setup do

    @service1 = Service.construct("12","calle 132 a # 19-43")
    @service1.save
    @service2 = Service.construct("19","kra 132 a # 19-43")
    @service2.save
    @service3 = Service.construct("88","calle 132BIS # 19-43")
    @service3.save

    @taxi = Taxi.get_or_create("123")
    @pos = Position.new(:latitude=>123,:longitude=>456,:taxi_id=>@taxi.id)
    @pos.save

    @taxi2 = Taxi.get_or_create("1243")
    @pos2 =  Position.new(:latitude=>123,:longitude=>456,:taxi_id=>@taxi2.id)
    @pos2.save

  end

  test "verify setup" do
    assert Taxi.all.size == 2
    assert Taxi.first.positions.size == 1, "There must be 1 positions but there are #{Taxi.first.positions.size}"
    assert Service.get_by_state(Service.confirmed).size == 0
  end

  test "confirm service1" do

    put :update, {:format=>:json, :id=>@service1.id, :state=>"blah", :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)
    assert @service1.is_pending, "expected #{Service.pending} but was #{@service1.get_state}"
    assert @service1.get_state == Service.pending

    put :update, {:format=>:json, :id=>@service1.id, :state=>Service.confirmed, :taxi_id=>@taxi.id}
    resp = MultiJson.load(@response.body)
    should_match_service(resp, @service1)
    assert @service1.reload.is_confirmed, "expected service confirmed but was #{@service1.get_state}"

  end

  test "confirm + complete service1" do

    assert_difference 'Service.all.size',1 do
      post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    end

    assert_no_difference 'Service.all.size' do
      #confirming service
      @service = Service.last
      put :update, {:format=>:json, :id=>@service.id, :state=>Service.confirmed, :taxi_id=>@taxi.id}
      @service = @service.reload
      assert @service.is_confirmed
      assert @service.taxi_id == @taxi.id
      resp = MultiJson.load(@response.body)
      should_match_service(resp, Service.last)

      #marking as done
      put :update, {:format=>:json, :id=>@service.id, :state=>Service.complete, :taxi_id=>@taxi.id, :verification_code=>"99"}

      @service = @service.reload
      assert @service.is_complete , " service's state was #{@service.get_state} "
      should_match_service(MultiJson.load(@response.body),@service)
    end

  end

  test "confirm + complete + cancel should raise Service::StateChangeError" do

    post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.confirmed, :taxi_id=>@taxi.id}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.complete, :taxi_id=>@taxi.id, :verification_code=>"99"}

    assert Service.last.is_complete

    put :update, {:format=>:json, :id=>Service.last.id, :state=> Service.cancelled}
    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "confirm + complete + abandon should raise Service::StateChangeError" do

    post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.confirmed, :taxi_id=>@taxi.id}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.complete, :taxi_id=>@taxi.id, :verification_code=>"99"}

    assert Service.last.is_complete

    put :update, {:format=>:json, :id=>Service.last.id, :state=> Service.abandoned, :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "confirm + complete + pending should raise Service::StateChangeError" do

    post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.confirmed, :taxi_id=>@taxi.id}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.complete, :taxi_id=>@taxi.id, :verification_code=>"99"}

    assert Service.last.is_complete

    put :update, {:format=>:json, :id=>Service.last.id, :state=> Service.pending, :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "confirm + cancel should cancel" do

    post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.confirmed, :taxi_id=>@taxi.id}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.cancelled}

    assert Service.last.is_canceled

  end

  test "create + cancel should cancel" do

    post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.cancelled}

    assert Service.last.is_canceled

  end

  test "create + abandon should raise Service::StateChangeError" do

    post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.abandoned, :taxi_id=>@taxi.id}

    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "create + confirm + abandon should abandon" do
    post :create, {:format=>:json, :address=>"a", :verification_code=>"99"}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.confirmed, :taxi_id=>@taxi.id}
    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.abandoned, :taxi_id=>0}

    should_contain_error_message(@response, Service::StateChangeError)

    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.abandoned, :taxi_id=>@taxi.id}
    assert Service.last.is_abandoned

    put :update, {:format=>:json, :id=>Service.last.id, :state=>Service.abandoned, :taxi_id=>@taxi.id}
    should_contain_error_message(@response, Service::StateChangeError)

  end

  test "get to index with no params should return all services" do

    get :index ,{:format=>:json}
    services = MultiJson.load(@response.body)
    should_contain_service(services,@service1)
    should_contain_service(services,@service2)
    should_contain_service(services,@service3)
    assert Service.all.size==3

  end

  test "get to index with params should return only specific" do

    put :update, {:format=>:json, :id=>@service2.id, :state=>Service.confirmed, :taxi_id=>Taxi.last.id}

    get :index ,{:format=>:json, :taxi_id=>Taxi.last.id}
    services = MultiJson.load(@response.body)
    should_contain_service(services,@service2)
    should_contain_service(services,@service1)
    should_contain_service(services,@service3)
    assert services.size==3


  end

  test "post to create with latitude and longitude should init those attrs" do
    address = 'calle 132 a # 19-43'
    verification_code = '12'
    latitude = 12.32
    longitude = 13.45
    assert_difference 'Service.all.size',1 do
      post :create, {:format=>:json, :address=>address, :verification_code=>verification_code,:latitude=>latitude,:longitude=>longitude}
    end
    s = Service.last
    assert s.address == address
    assert s.verification_code == verification_code
    assert s.latitude == latitude
    assert s.longitude == longitude

  end

  test 'post with no lat should not init lat nor lon' do
    address = 'calle 132 a # 19-43'
    verification_vode = '12'
    assert_difference 'Service.all.size',1 do
      post :create, {:format=>:json, :address=>address, :verification_code=>verification_vode}
    end
    s = Service.last
    assert s.address == address
    assert s.verification_code == verification_vode
    assert s.longitude == nil, "longitude shold be nil but was #{s.longitude}"
    assert s.latitude == nil
  end




end
























