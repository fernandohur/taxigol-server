class Company < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :drivers
  has_many :tokens
end
