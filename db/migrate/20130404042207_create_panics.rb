class CreatePanics < ActiveRecord::Migration
  def change
    create_table :panics do |t|
      t.integer :position_id

      t.timestamps
    end
  end
end
