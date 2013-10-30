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

  validates :verification_code, presence: true
  validates :address, presence: true
  validates :state, presence: true

  after_create :notify_creation
  after_save :notify_save

  ################
  ## Attributes ##
  ################
  attr_accessible :taxi_id, 
    :verification_code, 
    :address, 
    :service_type, 
    :latitude, 
    :longitude,
    :state,
    :tip, 
    :user_id, 
    :crossroad
  belongs_to :taxi

  ##################
  ## Constructors ##
  ##################

  # @Overrides
  # Creates a new service and generates a crossroad value
  def Service.create(service_hash)
      raise ArgumentError unless ServiceTypes::ALL.include? service_hash["service_type"]
      crossroad = Service.create_crossroad(service_hash["address"])
      service_hash["crossroad"] = crossroad
      super(service_hash)
  end

  #############
  ## Methods ##
  #############

  # returns a crossroad given an address
  def Service.create_crossroad(valor)
    complete_crossroad = valor
    odd_or_even = ""
    first_words = ""
    sur = ""

    #Para el caso de la forma first_words number - odd_or_even (sur)?
    #Se obtiene lo que va después del "- No.", es decir el identificador
    reg_exp = valor.scan(/-\ *\d+/)
    if reg_exp.size != 0
       # Se obtiene las coordenadas que hacen parte de la dirección, lo que va hasta el "-"
       first_words = valor.split(/\-/).first

       numbers = reg_exp.first.scan(/\d+/)
       #Se transforma el identificador a entero
       identificador = numbers.first.to_i
       if identificador.even?
          odd_or_even = "par"
       else
         odd_or_even = "impar"
       end
       # si la dirreción es en el sur o no
       if valor.scan(/\-\ *\d+\ *(?:sur$|s$|sur |s )/i).size !=0
         sur = " sur"
       end
    else
      # para el caso en donde no hay - y hay 3 digitos e.g: "Cll 24 B 27 A 41"
      # se obtiene una lista de los digitos que hacen parte de la dirección
      reg_exp_2 = valor.scan(/\d+/)
      if reg_exp_2.size >= 3
        #se obtiene el tercer digito que pertenece al identificador de las coordenadas
        identificador2 = reg2[2].to_i
        #se obtiene las coordenadas sin el identificador
        first_words = valor.split(/#{numb2}/).first
        if identificador2.even?
          odd_or_even = "par"
        else
          odd_or_even = "impar"
        end
        # si la dirección es en el sur o no
        if valor.scan(/#{numb2}\ *(?:sur$|s$|sur |s )/i).size != 0
           sur = " sur"
        end
      end

    end

    if first_words != "" && odd_or_even != ""
      complete_crossroad = first_words + sur + " " + odd_or_even
    end
    return complete_crossroad
  end

  # Updates the service with the given id with the new service as a hash
  # Note that this method can throw a StateChangeError if the update is illegal
  # @param id the id of the service
  # @param service_hash a hash representing the service (like a json)
  def Service.update(id, service_hash)
    service = Service.find(id)
    state = service_hash[:state]
    taxi_id = service_hash[:taxi_id]
    verification_code = service_hash[:verification_code]
    service.update_state(state, taxi_id, verification_code)  
    return service.reload       
  end

  # this method is executed after the service is created
  def notify_creation
    sender = TaxiMessageSender.new
    type = self.service_type
    tag =""
    if type == ServiceTypes::VALE_TV
       tag = 'Teleclub'
    elsif type == ServiceTypes::VALE_TC
       tag = 'Taxi verdes'
    end
    sender.notify_create_service(id, tag)
  end


  # this method is executed after the service's {@link Service#save} is called
  def notify_save
      if is_canceled
        sender = TaxiMessageSender.new
        service_taxi = self.taxi
        if  service_taxi != nil && service_taxi.current_driver_id != nil
          sender.notify_update('Servicio cancelado',service_taxi.current_driver_id,id)
        end

      end
  end

  # Updates the Service's state
  # @param state a string with the following posible 
  # values {:confirmado, :cancelado, :abandonado, :cumplido}. 
  # Any other value will raise a StateChange
  # @param taxi_id the taxi's id, this value can be nil when not necesary
  # @param verification_code a string representig the verification code, tipically
  # a 2 digit number passed as a string.
  def update_state(state, taxi_id = nil, verification_code = nil)
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
      raise StateChangeError, "state '#{state}' is not a valid Service state"
    end

  end

  def Service.get(params={})
    return Service.where("").order(:created_at).reverse_order.limit(50)
  end

  # returns all the services with the given state
  def Service.get_by_state(state)
  	Service.where(" state = '#{state}'")
  end

  # returns all the pending or confirmed services
  # owned by a taxi with id #{taxi_id}
  def Service.get_pending_or_confirmed(taxi_id)
    Service.where(" taxi_id = #{taxi_id} OR state = '#{Service.pending}' ")
  end

  # GIVEN that service is not nil
  # updates a service to state=confirm
  # @raises StateChangeError
  def Service.update_confirm(service, taxi_id)
    raise StateChangeError , "Taxi service state was #{service.state}, cannot change to #{Service.confirmed}" unless service.is_pending
    raise StateChangeError, "Taxi service cannot be confirmed by more than one taxi. Was already confirmed by #{service.taxi_id}" if service.taxi_id!=nil
    service.state = confirmed
    service.taxi_id = taxi_id
    service.save!
  end

  # given that service is not nil, it will
  # attempt to cancel it
  # @raises StateChangeError
  def Service.update_cancel(service)
    raise StateChangeError, "Taxi service with id #{service.id} was already canceled " if service.is_canceled
    raise StateChangeError, "Taxi service cannot be cancelled if completed" if service.is_complete
    service.state = cancelled
    service.save!
  end

  # given service is not nil, will attempt to abandon it
  def Service.update_abandon(service, taxi_id)
    raise StateChangeError, "Service.taxi_id was #{service.taxi_id} but taxi_id was #{taxi_id}" if service.taxi_id != taxi_id.to_i
    raise StateChangeError, "Service with id #{service.id} had state #{service.state}" unless service.is_confirmed
    raise StateChangeError, 'Service cannot be abandoned if already complete' if service.is_complete
    raise StateChangeError, 'Service cannot be re-abandoned' if service.is_abandoned
    if service.is_confirmed && service.taxi_id == taxi_id
      service.state = Service.abandoned
      service.save!
    end
  end

  # given service is no nil, will attempt to update it's state
  # to cumplido
  def Service.update_cumplido(service, taxi_id, verification_code)
    raise StateChangeError, "service with id #{service.id} has verification code #{service.verification_code} but verification code was #{verification_code}" if service.verification_code != verification_code
    raise StateChangeError, "service with id #{service.id} has taxi_id of #{service.taxi_id} but taxi_id param was #{taxi_id}" if service.taxi_id != taxi_id.to_i
    raise StateChangeError, "service with id #{service.id} had state #{service.state} " if !service.is_confirmed
    if service.taxi_id == taxi_id && service.verification_code == verification_code && service.is_confirmed
      service.state = Service.complete
      service.save!
    end
  end

  ####################
  ## Helper methods ##
  ####################

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

  ##############
  # Exceptions #
  ##############

  #
  # This exceptions is raised whenever there is an illegal state change.
  # Allowed changes are as follows:
  # 1. pending => confirmado|cancelled
  # 2. confirmado => cancelled | abandoned | complete
  #
  class StateChangeError < ArgumentError
  end

end
