class AddDeviceToApidUser < ActiveRecord::Migration
  def change
    add_column :apid_users, :device, :string
  end
end
