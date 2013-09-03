class ApidUser < ActiveRecord::Base
  attr_accessible :user_id, :value, :device

  belongs_to :user


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

end
