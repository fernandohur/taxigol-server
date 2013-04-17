class Taxi < ActiveRecord::Base
  attr_accessible :installation_id
  # attr_accessible :title, :body
  has_many :positions
  has_many :services

  def get_last_position
    self.positions.last
  end

  # finds a taxy by the given installation_id, if not found, creates a new one
  # Works kind of like a find_or_create
  def Taxi.auth(installation_id)
    taxi = Taxi.find_by_installation_id(installation_id)
    if taxi == nil
      taxi = Taxi.new(:installation_id => installation_id)
      taxi.save!
    end
    return taxi
  end

end
