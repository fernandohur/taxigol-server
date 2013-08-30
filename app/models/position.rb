#
# the Position class represents a taxi's position in space
# A position is identified by a latitude, longitude and the id of the taxi
# who created the position.
# If a taxi's position changes, a new Position object is created, a Position object 
# is not updated.
#
class Position < ActiveRecord::Base
	
	attr_accessible :latitude, :longitude, :taxi_id
	belongs_to :taxi

	def as_json
		json = super
		json.delete(:created_at.to_s)
		json.delete(:updated_at.to_s)
		return json
	end

end
