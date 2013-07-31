require 'exceptions/no_position_error'
class Taxi < ActiveRecord::Base

  attr_accessible :installation_id, :current_driver_id
  # attr_accessible :title, :body
  has_many :positions
  has_many :services
  has_many :drivers

  # finds a taxi by the given installation_id, if not found, creates a new one
  def Taxi.get_or_create(installation_id)
    placa = installation_id
    if placa == nil || placa.size < 6 || (placa =~/[a-zA-Z]{3}[0-9]{3}/) != 0
      raise ArgumentError, "placa #{installation_id} cannot be nil or size cannot be less than 6 and must match regex"
    end
    taxi = Taxi.find_by_installation_id(installation_id)
    if taxi == nil
      taxi = Taxi.new(:installation_id => installation_id)
      taxi.save!
    end
		return taxi
  end

	def get_last_position
    pos = self.positions.last
    return pos if pos
    raise NoPositionError, "taxi #{id} has #{positions.size} positions" if pos == nil
	end

  def Taxi.get_drivers(taxi_id)
    Taxi.find(taxi_id).drivers
  end

end
