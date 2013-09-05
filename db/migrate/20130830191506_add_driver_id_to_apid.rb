class AddDriverIdToApid < ActiveRecord::Migration
  def change
    add_column :apids, :driver_id, :integer
  end
end
