class ApidUser < ActiveRecord::Base
  attr_accessible :user_id, :value, :device

  belongs_to :user


  #@deprecated
  def ApidUser.get_or_create(apid_usr, user_id)
    usr_id = user_id.to_s
    if usr_id  == nil || (usr_id =~/\d+/) != 0
      raise ArgumentError, "id #{usr_id} cannot be nil or has to be digits and must match regex"
    end
    apid_user = ApidUser.find_by_user_id(usr_id)
    if apid_user == nil
      apid_user = ApidUser.new(apid_usr)
      apid_user.save!
    else
      apid_user.update_attributes(apid_usr)
    end
    return apid_user
  end

  # removes all previous ApidUser associated with :user_id
  # creates a new one
  # @apid_user_hash a hash representing the ApidUser
  # the hash must contain {:user_id, :value, :device}
  def ApidUser.create_or_update(apid_user_hash)
    user_id = apid_user_hash[:user_id]
    size = ApidUser.where(:user_id=>user_id).size  
    if size != 0
      ApidUser.where(:user_id=>user_id).delete_all
    end
    return ApidUser.create(apid_user_hash)
  end

end
