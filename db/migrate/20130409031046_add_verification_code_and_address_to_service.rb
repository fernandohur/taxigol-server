class AddVerificationCodeAndAddressToService < ActiveRecord::Migration
  def change
    add_column :services, :verification_code, :string
    add_column :services, :address, :string
  end
end
