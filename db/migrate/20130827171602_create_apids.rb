class CreateApids < ActiveRecord::Migration
  def change
    create_table :apids do |t|
      t.text :value

      t.timestamps
    end
  end
end
