class CreateMapObject < ActiveRecord::Migration
 	#attr_accessible :category, :expire_date, :latitude, :longitude, :expirable

  def up
  	create_table :map_objects do |t|
  		t.string :category
  		t.datetime :expire_date
  		t.float :latitude
  		t.float :longitude
  		t.boolean :expirable

      t.timestamps
  	end

  end

  def down
  	drop_table :map_objects
  end
end
