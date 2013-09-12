class AddCrossroadToService < ActiveRecord::Migration
  def change
    add_column :services, :crossroad, :string
  end
end
