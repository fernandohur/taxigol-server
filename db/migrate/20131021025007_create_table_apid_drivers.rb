class CreateTableApidDrivers < ActiveRecord::Migration
  def change
    create_table :apid_drivers do |t|
      t.string :value
      t.integer :driver_id
      t.string :device

      t.timestamps
    end
  end
end
