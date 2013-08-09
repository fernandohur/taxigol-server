class ServicesController < ApplicationController
<<<<<<< HEAD
=======

>>>>>>> ceduquey
  # GET /services
  # GET /services.json
  #params :taxi_id optionally receives a taxi id in which case returns all Services who's taxi_id matches the parameter
  def index
    taxi_id = params[:taxi_id]
<<<<<<< HEAD
    if taxi_id then
      @services = Service.find_all_by_taxi_id(taxi_id)
=======
    if taxi_id && taxi_id.to_s.length>0
      @services = Service.get_pending_or_confirmed(taxi_id)
>>>>>>> ceduquey
    else
      @services = Service.all
    end

    respond_to do |format|
<<<<<<< HEAD
=======
      format.html # index.html.erb
>>>>>>> ceduquey
      format.json { render json: @services }
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @service = Service.find(params[:id])

    respond_to do |format|
<<<<<<< HEAD
=======
      format.html # show.html.erb
>>>>>>> ceduquey
      format.json { render json: @service }
    end
  end

  # GET /services/new
  # GET /services/new.json
  def new
    @service = Service.new

    respond_to do |format|
<<<<<<< HEAD
=======
      format.html # new.html.erb
>>>>>>> ceduquey
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
<<<<<<< HEAD
    @service = Service.construct(params[:verification_code],params[:address])

    respond_to do |format|
      if @service.save
        Parse.send_service_create(@service)
        format.html { redirect_to @service, notice: 'service request was successfully created.' }
        format.json { render json: @service, status: :created, location: @service }
      else
        format.html { render action: "new" }
=======
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
>>>>>>> ceduquey
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.json
  def update
<<<<<<< HEAD

    @service = Service.find(params[:id])
    @service.update_state(params[:state], params[:taxi_id], params[:verification_code])
    respond_to do |format|
      format.json {render json: @service}
    end

  rescue ArgumentError => e2
    render_error(e2)
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

  def reset
    x = Service.delete_all
    respond_to do |format|
      format.json {render json: x}
    end
  end

  def pie_graph
    g = Gruff::Pie.new("600x500")
    g.hide_title = true
    g.title="Cumplimiento de los taxis"
    g.theme = graph_theme

    x = Service.get_states_count
    puts(x)
    x.each_with_index do |f, i|
      somevar = x[i]
      g.data(somevar['state'], somevar['TotalCount'])
    end

    headers["Content-Type"] = "image/png"
    send_data(g.to_blob, :type => "image/png", :disposition => "inline")
  end

  def graph_theme
    {
        :colors => ["#DB2626", "#6A6ADB", "#64D564", "#F727F7", "#EBEB20", "#303030", "#12ABAD", "#808080", "#B7580B", "#316211"],
        :marker_color => "#AAAAAA",
        :background_colors => ["#FFFFFF", "#FFFFFF"]
    }
  end
=======
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

>>>>>>> ceduquey



end
