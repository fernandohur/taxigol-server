#
# The Driver class, represents a taxi driver.
#
class Driver < ActiveRecord::Base

  attr_accessible :cedula, :name, :taxi_id, :password, :cel_number, :image

	validates_uniqueness_of :cedula
  belongs_to :taxi

  has_attached_file :image, styles: {
      small: '125x125>'
  }

  #
  # Creates a new driver
  # @param name: a string representing the name of the driver
  # @param cedula: a string representing the cedula/id of the driver
  # @param password: a string for the password
  # @param placa: a string that must match 'XYZ123'
  # @param cel_number: a string representing the driver's phone number
  #
  def Driver.construct(name,cedula, password, placa, cel_number="")
    taxi = Taxi.get_or_create(placa)
    driver = Driver.new(:name=>name,:cedula=>cedula,:taxi_id=>taxi.id, :password=>password, :cel_number => cel_number)
    
    return driver
  end

  #
  # returns nil if username,password does not match anything, else returns
  # the driver object and updates the taxi's current driver
  # @param username: equivalent to 'cedula'
  # @param password: the driver's password
  #
  def Driver.auth(username, password)

    driver = Driver.find_by_cedula(username)

    if driver == nil
      return nil
    elsif driver.password == password
    	taxi = driver.taxi
    	taxi.current_driver_id = driver.id
    	taxi.save!
      return driver
    else
      return nil
    end
  end

  #
  # Returns a list off all the driver's asociated with a taxi_id
  #
  def Driver.get_by_taxi_id(taxi_id)
		Driver.where("taxi_id = #{taxi_id}")
  end


end
