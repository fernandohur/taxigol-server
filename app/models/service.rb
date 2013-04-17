require "exceptions/state_change_error"

=begin
The Service class, represents a "Servicio de Taxi". It is created when a user makes a taxi request
and can hold up to 5 different states
  - :pendiente meaning that the user has made the request but no taxi has answered yet
  - :confirmado meaning that a taxi has promised to pick up the user
  - :cancelado meaning that the user does not wish the taxi service
  - :abandonado meaning that the taxi driver arrived at the address and there was no user
  - :cumplido when the taxi successfully picks up the user and verifies the confirmation_code
=end
class Service < ActiveRecord::Base
  attr_accessible :taxi_id, :verification_code, :address
  belongs_to :taxi

  #
  # This method should be called to construct the Service instead of calling Service.new
  #
  def Service.construct(verification_code, address)
    s = Service.new(:taxi_id=>nil,:verification_code=>verification_code,:address=>address)
    s.state = Service.pending.to_s
    return s
  end

  #
  # Updates the Service's state
  #state a string with the following posible values {:confirmado, :cancelado, :abandonado, :cumplido}. Any other value will raise an ArgumentError
  #
  def update_state(state, taxi_id=nil, verification_code=nil)
    state = state.intern
    taxi_id = taxi_id.to_i
    if state == Service.confirmed
      Service.update_confirm(self,taxi_id)
    elsif state == Service.cancelled
      Service.update_cancel(self)
    elsif state == Service.abandoned
      Service.update_abandon(self, taxi_id)
    elsif state == Service.complete
      Service.update_cumplido(self, taxi_id, verification_code)
    else
      raise ArgumentError, "state '#{state}' is not a valid Service state"
    end

  end


  def Service.get_states_count
    ActiveRecord::Base.connection.execute("SELECT state,
         COUNT(state) TotalCount
    FROM Services
GROUP BY state
  HAVING COUNT(state) > 0")
  end

  # Given that service is not nil
  def Service.update_confirm(service, taxi_id)
    raise StateChangeError , "Taxi service state was #{service.state}, cannot change to #{Service.confirmed}" unless service.is_pending
    raise StateChangeError, "Taxi service cannot be confirmed by more than one taxi. Was already confirmed by #{service.taxi_id}" if service.taxi_id!=nil
    service.state = confirmed
    service.taxi_id = taxi_id
    service.save!
  end

  def Service.update_cancel(service)
    raise StateChangeError, "Taxi service with id #{service.id} was already canceled " if service.is_canceled
    raise StateChangeError, "Taxi service cannot be cancelled if completed" if service.is_complete
    service.state = cancelled
    service.save!
  end

  def Service.update_abandon(service, taxi_id)
    raise StateChangeError, "Service.taxi_id was #{service.taxi_id} but taxi_id was #{taxi_id}" if service.taxi_id != taxi_id.to_i
    raise StateChangeError, "Service with id #{service.id} had state #{service.state}" unless service.is_confirmed
    raise StateChangeError, "Service cannot be abandoned if already complete" if service.is_complete
    raise StateChangeError, "Service cannot be re-abandoned" if service.is_abandoned
    if service.is_confirmed && service.taxi_id == taxi_id
      service.state = Service.abandoned
      service.save!
    end
  end

  def Service.update_cumplido(service, taxi_id, verification_code)
    raise StateChangeError, "service with id #{service.id} has verification code #{service.verification_code} but verification code was #{verification_code}" if service.verification_code != verification_code
    raise StateChangeError, "service with id #{service.id} has taxi_id of #{service.taxi_id} but taxi_id param was #{taxi_id}" if service.taxi_id != taxi_id.to_i
    raise StateChangeError, "service with id #{service.id} had state #{service.state} " if !service.is_confirmed
    if service.taxi_id == taxi_id && service.verification_code == verification_code && service.is_confirmed
      service.state = Service.complete
      service.save!
    end
  end

  def get_state
    state.intern
  end

  def is_confirmed
    get_state==Service.confirmed
  end

  def is_canceled
    get_state==Service.cancelled
  end

  def is_pending
    get_state==Service.pending
  end

  def is_complete
    get_state==Service.complete
  end

  def is_abandoned
    get_state==Service.abandoned
  end

  def Service.abandoned
    return :abandonado
  end

  def Service.confirmed
    return :confirmado
  end

  def Service.cancelled
    return :cancelado
  end

  def Service.complete
    return :cumplido
  end

  def Service.pending
    return :pendiente
  end

end
