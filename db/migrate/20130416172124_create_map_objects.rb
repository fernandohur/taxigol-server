class CreateMapObjects < ActiveRecord::Migration
  def change
    create_table :map_objects do |t|
      t.float :latitude
      t.float :longitude
      t.string :category
      t.text :description

      t.timestamps
    end
  end
end
