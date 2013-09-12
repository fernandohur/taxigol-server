require 'test_helper'

class DriverTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess
  #=========================
  # helper methods
  #=========================

  # asserts that the attributes name, cedula
  # taxi_id and password match between the two taxi objects
  def drivers_should_match(driver1, driver2)
    assert driver1.name == driver2.name
    assert driver1.cedula == driver2.cedula
    assert driver1.taxi_id == driver2.taxi_id, "taxi_id was #{driver1.taxi_id} instead of #{driver2.taxi_id}"
    assert driver1.password == driver2.password
  end

  setup do

    @placa = 'ABC301'
  	@taxi = Taxi.get_or_create(@placa)

    cedula = '102020394875'
    celular = '3008734028'
    password = 'mypwd'
    name = 'richard the third'
    placa = 'ABC987'
    
    image = fixture_file_upload 'sample_file.png'

    driverHash = Hash.new
    driverHash['name'] =  name
    driverHash['cedula'] = cedula
    driverHash['image'] = image
    driverHash['cel_number'] = celular
    driverHash['password'] = password

    @driver = Driver.construct(driverHash, @placa)
    @driver.save
    @driver.reload

  end

	#
  # test that Driver.construct does indeed assign values accoordingly
  #
  test 'test construct driver should set correct attrs' do

    name = 'pablo'
    cedula = '1020345612'
    placa = 'abc123'
    password = '1234'
    cel_number = '123345'
    extend ActionDispatch::TestProcess
    image = fixture_file_upload 'sample_file.png'

    driverHash = Hash.new
    driverHash['name'] =  name
    driverHash['cedula'] = cedula
    driverHash['image'] = image
    driverHash['cel_number'] = cel_number
    driverHash['password'] = password

    driver = Driver.construct(driverHash, placa)

    driver.save!

    assert_equal driver.name, name
    assert_equal driver.cedula, cedula
    assert_equal driver.taxi_id, Taxi.get_or_create(placa).id
    assert_equal driver.password, password
    assert_equal driver.cel_number, cel_number
  end

  test 'creating driver with nil placa should raise error' do

	  assert_raises ArgumentError do
			name = 'pablo'
	    cedula = '1020345612'
	    password = '1234'
      extend ActionDispatch::TestProcess
      image = fixture_file_upload 'sample_file.png'

      driverHash = Hash.new
      driverHash['name'] =  name
      driverHash['cedula'] = cedula
      driverHash['image'] = image
      driverHash['password'] = password

      driver = Driver.construct(driverHash, nil)
	    driver.save!

	    assert driver.name == name
	    assert driver.cedula == cedula
	    assert driver.taxi_id == Taxi.get_or_create(placa).id
	    assert driver.password == password
	  end

  end

  #
  # test that authorizing a driver with non existing creds will return nil
  #
  test 'auth for non existing credentials should return nil driver' do
    
    driver = Driver.auth('a','b')
    assert driver == nil

  end

  #
  # Attempting to authorize a driver with wrong credentials will return a nil driver
  #
  test 'auth with incorrect credentials should return nil driver' do

    driver2 = Driver.auth(@driver.cedula,'password_')
    assert driver2 == nil

    driver2 = Driver.auth(@driver.cedula<<'_', @driver.password)
    assert driver2 == nil

  end

  #
  # Attepmting to authorize a driver with correct credentials will return the driver with the given username
  #
  test 'auth with correct credentials should return correct driver' do

    driver2 = Driver.auth(@driver.cedula,@driver.password)
    driver3 = Driver.find_by_cedula(@driver.cedula)

    drivers_should_match(@driver, driver2)
    drivers_should_match(@driver, driver3)
  end

  test 'auth with correct creds should update taxi current driver' do

  	@taxi.current_driver_id = -1
  	assert_equal @taxi.current_driver_id, -1

  	Driver.auth(@driver.cedula, @driver.password)
  	@taxi.reload
  	assert_equal @taxi.current_driver_id, @driver.id

  end

  test 'Given 2 drivers have the same placa, the taxi should have two drivers ' do

    #first we test that the taxi is correctly assigned to the existing driver
    assert @driver.taxi_id == Taxi.get_or_create(@placa).id
    assert Taxi.get_or_create(@placa).drivers.include? @driver

    #now we create a second driver but bear in mind that they share the same @placa
    extend ActionDispatch::TestProcess
    image = fixture_file_upload 'sample_file.png'

    driverHash = Hash.new
    driverHash['name'] =  'robert'
    driverHash['cedula'] = '1020362'
    driverHash['image'] = image
    driverHash['cel_number'] = '300832422'
    driverHash['password'] = '1234'

    driver2 = Driver.construct(driverHash, @placa)
    driver2.save!

    #now we test that the taxi now has a new driver            .
    assert driver2.taxi_id == Taxi.get_or_create(@placa).id
    assert Taxi.get_or_create(@placa).drivers.include? driver2

    assert Taxi.get_drivers(Taxi.get_or_create(@placa)).include?driver2
    assert Taxi.get_drivers(Taxi.get_or_create(@placa)).include?@driver
  end

  test 'registering two drivers with same cedula should return exception' do

    driverHash = Hash.new
    driverHash['name'] =  'rob'
    driverHash['cedula'] = @driver.cedula
    driverHash['password'] = 'mypass'

    assert_raises ActiveRecord::RecordInvalid do
      d = Driver.construct(driverHash, 'abc123')
      d.save!
    end

  end


end


















