class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.float :latitude
      t.float :longitude
      t.integer :taxi_id

      t.timestamps
    end
  end
end
