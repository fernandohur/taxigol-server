class Panic < ActiveRecord::Base
  attr_accessible :position_id
  belongs_to :position

  def Panic.construct (taxi_id)

    taxi = Taxi.find(taxi_id)

    position = taxi.get_last_position
    raise NoPositionError, "Taxi with id #{taxi_id} does not have any position" if position == nil
    return Panic.new(:position_id=>position.id)
  rescue ActiveRecord::RecordNotFound
    raise NoTaxiError, "Taxi with id #{taxi_id} must exist" if taxi == nil
  end

  def get_taxi
    position.taxi
  end

end
