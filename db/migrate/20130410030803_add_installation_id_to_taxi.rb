class AddInstallationIdToTaxi < ActiveRecord::Migration
  def change
    add_column :taxis, :installation_id, :string
  end
end
