class Position < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :taxi_id
  belongs_to :taxi
end
