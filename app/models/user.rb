class User < ActiveRecord::Base
  attr_accessible :phone_number, :name, :email,:image_url

  has_one :apid_user
end
