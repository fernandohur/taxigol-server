class CreateApiusrs < ActiveRecord::Migration
  def change
    create_table :apiusrs do |t|
      t.string :value
      t.references :user

      t.timestamps
    end
    add_index :apiusrs, :user_id
  end
end
