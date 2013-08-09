class RemovePhotoUrlFromDriver < ActiveRecord::Migration
  def up
    remove_column :drivers, :photo_url
  end

  def down
    add_column :drivers, :photo_url, :string
  end
end
