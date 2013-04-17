class TaxisController < ApplicationController
  # GET /taxis
  # GET /taxis.json
  def index
    @taxis = Taxi.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxis }
    end
  end

  # GET /taxis/1
  # GET /taxis/1.json
  def show
    @taxi = Taxi.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxi }
    end
  end

  # GET /taxis/new
  # GET /taxis/new.json
  def new
    @taxi = Taxi.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxi }
    end
  end

  # GET /taxis/1/edit
  def edit
    @taxi = Taxi.find(params[:id])
  end

  # POST /taxis
  # POST /taxis.json
  def create

  end

  # PUT /taxis/1
  # PUT /taxis/1.json
  def update
    @taxi = Taxi.find(params[:id])

    respond_to do |format|
      if @taxi.update_attributes(params[:taxi])
        format.html { redirect_to @taxi, notice: 'Taxi was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxis/1
  # DELETE /taxis/1.json
  def destroy
    @taxi = Taxi.find(params[:id])
    @taxi.destroy

    respond_to do |format|
      format.html { redirect_to taxis_url }
      format.json { head :no_content }
    end
  end

  def reset
    num_deleted = Taxi.delete_all
    respond_to do |format|
      format.json {render json: num_deleted}
    end
  end

  #POST /taxis/auth.json
  def auth
    @taxi = Taxi.auth(params[:installation_id])
    respond_to do |format|
      format.json {render json: @taxi}
    end
  end

end

