class DriversController < ApplicationController


  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drivers }
    end
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
    @driver = Driver.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @driver }
    end
  end

  # POST /drivers
  # POST /drivers.json
  def create

    placa = params[:placa]
    cedula = params[:cedula]
    password = params[:password]
    name = params[:name]
		cel_number = params[:cel_number] 		
		@driver = Driver.construct(name, cedula, password, placa,cel_number)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render json: @driver, status: :created, location: @driver }
      else
        format.html { render action: "new" }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  #
  # POST /drivers/auth.json
  # @param :cedula || :username 
  # @param :password
  def auth
  	if params[:cedula]
    	username = params[:cedula]
  	else
  		username = params[:username]
  	end
    password = params[:password]
    @driver = Driver.auth(username, password)
    if @driver
      render_as_json(@driver)
    else
      render_message('wrong credentials, sry :)')
    end
  end

  # returns all the drivers that match a given taxi id
  # @path GET /drivers/get_drivers.json
  # @param :taxi_id 
  def get_drivers
    taxi_id = params[:taxi_id]
    @drivers = Driver.get_by_taxi_id(taxi_id)
    render_as_json @drivers
  end

  # updates a driver
  # PUT /drivers/1
  # PUT /drivers/1.json
  def update
    @driver = Driver.find(params[:id])
    respond_to do |format|
      if @driver.update_attributes(params[:driver])
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # removes all drivers
  # POST /drivers/reset
  def reset
    num_deleted = Driver.delete_all
    render_as_json num_deleted
  end
end
