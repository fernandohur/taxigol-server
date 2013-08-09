class CreateUsers < ActiveRecord::Migration
  def up
  	#attr_accessible :phone_number, :name, :email, :image_url
  	create_table :users do |t|
  		t.string :phone_number
  		t.string :name
  		t.string :email
  		t.string :image_url

  		t.timestamps
  	end
  end

  def down
  	drop_table :users
  end
end
