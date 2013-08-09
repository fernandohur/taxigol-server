class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :services, :type, :service_type
  end

  def down
  end
end
