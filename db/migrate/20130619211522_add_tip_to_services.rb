class AddTipToServices < ActiveRecord::Migration
  def change
    add_column :services, :tip, :string
  end
end
