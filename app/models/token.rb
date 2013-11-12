class Token < ActiveRecord::Base
  attr_accessible :company_id, :customer, :value, :price, :cost_center, :user_name
  validates_uniqueness_of :value
  belongs_to :company


  def Token.update(id, token_hash)
    token = Token.find(id)
    price = token_hash[:price]
    if price
      token.price = price
    end
    token.cost_center = token_hash[:cost_center]
    token.user_name = token_hash[:user_name]
    token.save!
    return token
  end

  def Token.validate(company_name, value)
    company = Company.find_by_name(company_name)
    if company !=nil
      token = Token.where("company_id='#{company.id}' AND value='#{value}'")
      return token.first
    end
    return nil
  end
end
