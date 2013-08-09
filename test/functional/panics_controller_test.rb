require 'test_helper'

class PanicsControllerTest < ActionController::TestCase


<<<<<<< HEAD
  test "create panic with no taxi should raise NoTaxiError" do

    Taxi.delete_all
    post :create, {:format=>:json, :taxi_id=>0}
    should_contain_error_message(@response, NoTaxiError)

  end

  test "create panic with no position should raise NoPositionError" do

    Taxi.delete_all
    taxi = Taxi.auth("asd")
    post :create, {:format=>:json, :taxi_id=>taxi.id}
    should_contain_error_message(@response, NoPositionError)

  end
=======
>>>>>>> ceduquey

end
