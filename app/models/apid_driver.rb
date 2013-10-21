class ApidDriver < ActiveRecord::Base
  attr_accessible :driver_id, :value, :device

  belongs_to :driver


  #@deprecated
  def ApidDriver.get_or_create(apid_drivr, driver_id)
    drvr_id = driver_id.to_s
    if drvr_id  == nil || (drvr_id =~/\d+/) != 0
      raise ArgumentError, "id #{drvr_id} cannot be nil or has to be digits and must match regex"
    end
    apid_driver= ApidUser.find_by_user_id(drvr_id)
    if apid_driver == nil
      apid_driver = ApidDriver.new(apid_drivr)
      apid_driver.save!
    else
      apid_driver.update_attributes(apid_drivr)
    end
    return apid_driver
  end

  # removes all previous ApidUser associated with :user_id
  # creates a new one
  # @apid_user_hash a hash representing the ApidUser
  # the hash must contain {:user_id, :value, :device}
  def ApidDriver.create_or_update(apid_driver_hash)
    driver_id = apid_driver_hash[:driver_id]
    size = ApidDriver.where(:driver_id=>driver_id).size
    if size != 0
      ApidDriver.where(:driver_id=>driver_id).delete_all
    end
    return ApidDriver.create(apid_driver_hash)
  end

end
