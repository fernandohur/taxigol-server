class AddCostCenterAndUserNameToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :cost_center, :string
    add_column :tokens, :user_name, :string
  end
end
