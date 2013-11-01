class Token < ActiveRecord::Base
  attr_accessible :company_id, :customer, :value, :price
  validates_uniqueness_of :value
  belongs_to :company


  def Token.validate(company_name, value)
    company = Company.find_by_name(company_name)
    if company !=nil
      token = Token.where("company_id='#{company.id}' AND value='#{value}'")
      return token.first
    end
    return nil
  end
end
