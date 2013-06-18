class Panic < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :taxi_id

  def Panic.construct(latitude, longitude, taxi_id)
		return Panic.new(:latitude=>latitude, :longitude=>longitude, :taxi_id=>taxi_id)
  end

end
