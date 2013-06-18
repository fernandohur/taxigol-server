require 'test_helper'

class TaxiTest < ActiveSupport::TestCase

  test 'Given that there are no taxis in the DB Calling Taxi get_or_create creates a new taxi' do

    Taxi.delete_all
    taxi = Taxi.get_or_create('123')

    assert taxi.installation_id == '123'
    assert Taxi.all.size == 1
    assert Taxi.last.id = taxi.id

  end

  test 'Calling get_or_create with existing installation_id does not create a new taxi' do

    Taxi.delete_all

    assert Taxi.all.size == 0

    taxi = Taxi.new(:installation_id=> "abc")
    taxi.save
    assert Taxi.all.size == 1

    taxi2 = Taxi.get_or_create("abc")

    assert taxi.id == taxi2.id
    assert taxi.installation_id == taxi2.installation_id
    assert Taxi.all.size == 1

  end

  test 'calling get last position on a taxi with no positions raises an error' do

    Taxi.delete_all

    taxi = Taxi.get_or_create('asd')
    assert_raises NoPositionError do
      taxi.get_last_position
    end

  end

  test 'calling get last position on a taxi with positions returns the last position' do

    Taxi.delete_all

    taxi = Taxi.get_or_create('asd')
    taxi.positions.new(:latitude=>12,:longitude=>23.9)
    taxi.save!

    last_pos = taxi.get_last_position
    assert last_pos.latitude == 12
    assert last_pos.longitude == 23.9

    taxi.positions.new(:latitude=>19,:longitude=>0.5)
    taxi.save!

    last_pos = taxi.get_last_position
    assert last_pos.latitude == 19
    assert last_pos.longitude == 0.5

  end


end
