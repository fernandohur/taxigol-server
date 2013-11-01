class AddPriceToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :price, :string
  end
end
