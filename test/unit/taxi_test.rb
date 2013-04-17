require 'test_helper'

class TaxiTest < ActiveSupport::TestCase

  test "Given that there are no taxis in the DB Calling Taxi auth creates a new taxi" do

    Taxi.delete_all
    taxi = Taxi.auth("123")

    assert taxi.installation_id == "123"
    assert Taxi.all.size == 1
    assert Taxi.last.id = taxi.id

  end

  test "Calling auth with existing installation_id does not create a new taxi" do

    Taxi.delete_all

    assert Taxi.all.size == 0

    taxi = Taxi.new(:installation_id=> "abc")
    taxi.save
    assert Taxi.all.size == 1

    taxi2 = Taxi.auth("abc")

    assert taxi.id == taxi2.id
    assert taxi.installation_id == taxi2.installation_id
    assert Taxi.all.size == 1

  end

end
