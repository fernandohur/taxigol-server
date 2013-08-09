class AddCelNumberToDriver < ActiveRecord::Migration
  def up
    add_column :drivers, :cel_number, :string
  end

  def down
  	remove_column :drivers, :cel_number
  end

end
