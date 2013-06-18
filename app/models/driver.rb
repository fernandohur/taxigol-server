class Driver < ActiveRecord::Base

  attr_accessible :cedula, :name, :photo_url, :taxi_id, :password, :cel_number

	validates_uniqueness_of :cedula
  belongs_to :taxi

  def Driver.construct(name,cedula, password, placa, cel_number="")
  	if placa == nil || placa.size < 6
  		raise ArgumentError, 'placa cannot be nil or size cannot be less than 6'
  	end
    taxi = Taxi.get_or_create(placa)

    driver = Driver.new(:name=>name,:cedula=>cedula,:taxi_id=>taxi.id, :password=>password, :cel_number => cel_number)
    return driver
  end

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

  def Driver.get_by_taxi_id(taxi_id)
		Driver.where("taxi_id = #{taxi_id}")
  end


end
