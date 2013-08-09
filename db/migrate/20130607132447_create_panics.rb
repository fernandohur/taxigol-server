class CreatePanics < ActiveRecord::Migration
  def up
  	#attr_accessible :latitude, :longitude, :taxi_id
  	create_table :panics do |t|
  		t.float :latitude
  		t.float :longitude
  		t.integer :taxi_id
  		
  		t.timestamps	
  	end

  end

  def down
  	drop_table :panics
  end
end
