class Token < ActiveRecord::Base
  attr_accessible :company_id, :customer, :value
  validates_uniqueness_of :value
  belongs_to :company
end
