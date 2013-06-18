class CreateServices < ActiveRecord::Migration
  #attr_accessible :taxi_id, :verification_code, :address, :latitude, :longitude,:state

  def up
  	create_table :services do |t|
  		t.integer :taxi_id
  		t.string :verification_code
  		t.string :address
  		t.string :state
  		t.float :latitude
  		t.float :longitude

  		t.timestamps
  	end
  end

  def down
  	drop_table :services
  end
end
