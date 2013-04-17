class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :state
      t.integer :taxi_id

      t.timestamps
    end
  end
end
