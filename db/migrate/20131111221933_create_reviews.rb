class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :comment
      t.integer :rating
      t.integer :user_id
      t.integer :driver_id
      t.integer :service_id

      t.timestamps
    end
  end
end
