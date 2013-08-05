class ServicesController < ApplicationController

  # GET /services
  # GET /services.json
  #params :taxi_id optionally receives a taxi id in which case returns all Services who's taxi_id matches the parameter
  def index
    taxi_id = params[:taxi_id]
    if taxi_id && taxi_id.to_s.length>0
      @services = Service.get_pending_or_confirmed(taxi_id)
    else
      @services = Service.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @services }
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @service = Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/new
  # GET /services/new.json
  def new
    @service = Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = Service.find(params[:id])
  end

  # POST /services
  # POST /services.json
  def create
    latitude = params[:latitude]
    longitude = params[:longitude]
    verification_code = params[:verification_code]
    address = params[:address]
    tip = params[:tip]
    service_type = params[:service_type]

    if tip
    	@service = Service.construct(verification_code, address, service_type, latitude,longitude, tip)
    else
    	@service = Service.construct(verification_code,address, service_type, latitude,longitude)
    end

    respond_to do |format|
      if @service.save
        message_sender = MessageSender.new
        message_sender.push_default('','service_id',@service.id.to_s)
        format.json { render json: @service, status: :created, location: @service }
      else
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.json
  def update
    begin
      @service = Service.find(params[:id])
      @service.update_state(params[:state],params[:taxi_id],params[:verification_code])
      render_as_json @service.reload
    rescue Service::StateChangeError => e
      render_error(e)
    end
  end

	# DELETE /services/1
  # DELETE /services/1.json
	def destroy
		@service = Service.find(params[:id])
		@service.destroy

		respond_to do |format|
			format.html { redirect_to services_url }
			format.json { head :no_content }
		end
	end

	# POST /services/reset
	def reset
		num_deleted = Service.delete_all
		respond_to do |format|
			format.json {render json: num_deleted}
		end
	end




end
