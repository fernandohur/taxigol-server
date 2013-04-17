class CreateTaxiRequests < ActiveRecord::Migration
  def change
    create_table :taxi_requests do |t|
      t.string :address
      t.boolean :confirm

      t.timestamps
    end
  end
end
