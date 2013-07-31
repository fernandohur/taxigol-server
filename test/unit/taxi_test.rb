require 'test_helper'

class TaxiTest < ActiveSupport::TestCase

  # GIVEN there are 0 taxis
  # THEN calling get_or_create will create a taxi
  test 'Given that there are no taxis in the DB Calling get_or_create creates a new taxi' do

    taxi = Taxi.get_or_create('ABC123')

    assert_equal taxi.installation_id, 'ABC123'
    assert_equal Taxi.all.size, 1
    assert_equal taxi.drivers.size,0
    assert_equal taxi.positions.size,0
    assert_equal taxi.services.size,0
    assert_nil taxi.current_driver_id
  end

  # GIVEN there is a taxi with installation_id <x>
  # THEN get_or_create(<x>) will not create a taxi
  # AND get_or_create(<x>) will return the existing taxi
  test 'Calling get_or_create with existing installation_id does not create a new taxi' do

    installation_id = "ASD123"

    taxi = Taxi.new(:installation_id=> installation_id)
    taxi.save

    taxi2 = Taxi.get_or_create(installation_id)

    assert taxi.id == taxi2.id
    assert taxi.installation_id == taxi2.installation_id
    assert Taxi.all.size == 1

  end

  #
  # GIVEN a taxi with no positions
  # THEN then calling get_last_position should raise a NoPositionError 
  #
  test 'calling get last position on a taxi with no positions raises an error' do

    taxi = Taxi.get_or_create('asd123')
    assert_raises NoPositionError do
      taxi.get_last_position
    end

  end

  # GIVEN a taxi with at least one position
  # THEN calling get_last_position should return the last position
  test 'calling get last position on a taxi with positions returns the last position' do

    taxi = Taxi.get_or_create('asd123')
    taxi.positions.new(:latitude=>12,:longitude=>23.9)
    taxi.save!

    last_pos = taxi.get_last_position
    assert last_pos.latitude == 12
    assert last_pos.longitude == 23.9

    # create 10 new positions, the 'new' one, should always be get_last_position
    num_tests = 10
    assert_difference 'Position.all.size',num_tests do 
      num_tests.times do |i|
        latitude = 100*rand
        longitude = 100*rand
        taxi.positions.new(:latitude=>latitude, :longitude=>longitude)
        taxi.save!

        pos = taxi.get_last_position
        assert_equal latitude, pos.latitude
        assert_equal longitude, pos.longitude
      end
    end
  end

  test 'Taxi.get_drivers should return an empty list if a taxi has no drivers' do
    taxi = Taxi.get_or_create('ABC123')
    taxi.save
    drivers = Taxi.get_drivers(taxi.id)
    assert drivers.empty?
    assert taxi.drivers.empty?
  end

  test 'Taxi.get_drivers should return all drivers asociated with a specific taxi' do
    plate = 'ABC123'

    taxi = Taxi.get_or_create(plate)
    taxi.save
    d1 = Driver.construct("name",1, "password", plate, "")
    d2 = Driver.construct("name",2, "password", plate, "")
    d3 = Driver.construct("name",3, "password", 'eda123', "")
    d4 = Driver.construct("name",4, "password", 'qwe234', "")
    d5 = Driver.construct("name",5, "password", plate, "")

    [d1,d2,d3,d4,d5].each { |driver| driver.save! }
    taxi.reload

    drivers = Taxi.get_drivers(taxi.id)
    assert_equal drivers.size,3
    drivers.each {|d| assert [d1,d2,d5].include? d}

  end

end
