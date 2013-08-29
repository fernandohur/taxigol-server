require 'exceptions/no_position_error'
class Taxi < ActiveRecord::Base

  attr_accessible :installation_id, :current_driver_id
  # attr_accessible :title, :body
  has_many :positions
  has_many :services
  has_many :drivers

  def Taxi.create(hash)
    installation_id = hash[:installation_id]
    return get_or_create(installation_id)
  end

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

  # using the current_driver_id attr returns the driver that matches
  # that id, if current_driver_id is nil (i.e. no current driver), returns nil
  def get_current_driver
    if current_driver_id
      return Driver.find(current_driver_id)
    else
      return nil unless current_driver_id
    end
  end

	def get_last_position
    pos = self.positions.last
    return pos if pos
    raise NoPositionError, "taxi #{id} has #{positions.size} positions" if pos == nil
	end

  # returns all the drivers that are asociated with a specified taxi
  # @param taxi_id the id of the taxi
  def Taxi.get_drivers(taxi_id)
    Taxi.find(taxi_id).drivers
  end

  def as_json(options={})
    json = super
    json[:position] = self.positions.last
    return json
  end

end
