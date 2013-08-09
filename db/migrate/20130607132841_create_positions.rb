class CreatePositions < ActiveRecord::Migration
  def up
  	create_table :positions do |t|
  		t.float :latitude
  		t.float :longitude
  		t.integer :taxi_id

  		t.timestamps
  	end
  end

  def down
  	drop_table :postitions
  end
end
