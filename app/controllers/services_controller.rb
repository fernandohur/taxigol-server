class ServicesController < ApplicationController
  # GET /services
  # GET /services.json
  #params :taxi_id optionally receives a taxi id in which case returns all Services who's taxi_id matches the parameter
  def index
    taxi_id = params[:taxi_id]
    if taxi_id then
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
    if !tip
    	@service = Service.construct(verification_code,address,latitude,longitude)
    else
    	@service = Service.construct(verification_code, address, latitude,longitude, tip)
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

  def pie_graph_for_taxi (taxi_id)
    g = Gruff::Pie.new("600x500")
    g.hide_title = true
    g.title="Cumplimiento del taxista"
    g.theme = graph_theme

    x = Service.get_taxi_states_count(taxi_id)
    puts(x)
    x.each_with_index do |f, i|
      somevar = x[i]
      g.data(somevar['state'], somevar['TotalCount'])
    end

    headers["Content-Type"] = "image/png"
    send_data(g.to_blob, :type => "image/png", :disposition => "inline")
  end

  def bar_graph
    g = Gruff::Bar.new("600x500")
    g.hide_title = true
    g.title="Cumplimiento del taxista"
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


end
