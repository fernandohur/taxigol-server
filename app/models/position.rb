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

	# finds the latest position created by a given taxi
	def Position.find_last(taxi_id)
		Position.where(:taxi_id=>taxi_id).order(:created_at).reverse_order.limit(1).first
	end

	# finds the date of the latest position object given a taxi_id.
	# Destroys all Positions older than that one. 
	# Note that given that the database stores at the second level,
	# if more than one position is created in a given second then
	# their created_at value will be equal
	def Position.delete_old(taxi_id)
		relation = Position.where(:taxi_id=>taxi_id)
		last = relation.last
		relation.delete_all("created_at <= '#{last.created_at}'")
	end

end
