class CreateTaxis < ActiveRecord::Migration
  def change
    create_table :taxis do |t|

      t.timestamps
    end
  end
end
