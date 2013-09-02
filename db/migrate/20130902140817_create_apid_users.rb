class CreateApidUsers < ActiveRecord::Migration
  def change
    create_table :apid_users do |t|
      t.string :value
      t.integer :user_id

      t.timestamps
    end
  end
end
