class AddImageToDrivers < ActiveRecord::Migration
  def self.up
    add_attachment :drivers, :image
  end

  def self.down
    remove_attachment :drivers, :image
  end
end
