class Review < ActiveRecord::Base
  attr_accessible :comment, :driver_id, :rating, :service_id, :user_id
  belongs_to :service
  belongs_to :user
  belongs_to :driver


  # @Overrides
  # Creates a new review
  def Review.create(review_hash)
    service = Service.find(review_hash["service_id"])
    review_hash["user_id"] = service.user_id
    review_hash["driver_id"] = service.taxi.current_driver_id
    super(review_hash)
  end

end
