class CreateTableCompaniesDrivers < ActiveRecord::Migration
  def change
    create_table :companies_drivers do |t|
      t.belongs_to :company
      t.belongs_to :driver
    end
  end
end
