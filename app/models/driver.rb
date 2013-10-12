#
# The Driver class, represents a taxi driver.
#
class Driver < ActiveRecord::Base

  attr_accessible :cedula, :name, :taxi_id, :password, :cel_number, :image

	validates_uniqueness_of :cedula
  belongs_to :taxi
  has_one :apid
  has_and_belongs_to_many :company
  has_attached_file :image, styles: {
      small: '125x125>'
  }

  #
  # Creates a new driver
  # @param driver: a hash representing the driver model
  # @param placa: a string that must match 'XYZ123'
  def Driver.construct(driver, placa)
    taxi = Taxi.get_or_create(placa)
    driver = Driver.new(driver)
    driver.taxi_id=taxi.id

    return driver
  end

  def Driver.create(hash)

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

  def as_json(options={})
    json = super
    json[:image_url] = image.url(:small)
    return json
  end


end
