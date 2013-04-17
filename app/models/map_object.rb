class MapObject < ActiveRecord::Base
  attr_accessible :category, :description, :latitude, :longitude
end
