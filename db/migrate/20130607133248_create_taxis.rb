class CreateTaxis < ActiveRecord::Migration
  def up
  	create_table :taxis do |t|
  		t.string :installation_id

  		t.timestamps
  	end
  end

  def down
  	drop_table :taxis
  end
end
