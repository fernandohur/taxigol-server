class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :value
      t.integer :company_id
      t.string :customer

      t.timestamps
    end
  end
end
