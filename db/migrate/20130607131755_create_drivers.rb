class CreateDrivers < ActiveRecord::Migration
  
  def up
  	create_table :drivers do |t|
      t.string :cedula, :null => false
      t.string :name, :null => false
      t.string :photo_url
      t.string :password, :null=>false
      t.integer :taxi_id, :null=>false
 
      t.timestamps
    end
  end

  def down
  	drop_table :drivers
  end
end
