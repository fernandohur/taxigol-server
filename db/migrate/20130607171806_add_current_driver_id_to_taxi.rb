class AddCurrentDriverIdToTaxi < ActiveRecord::Migration
  def up
    add_column :taxis, :current_driver_id, :integer
  end

  def down
  	remove_column :taxis, :current_driver_id
  end
end
