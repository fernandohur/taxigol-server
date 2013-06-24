class PositionsController < ApplicationController

  # @route /positions
  # @method GET
  # @return
  def index
    @positions = Position.all

    respond_to do |format|
      format.json { render json: @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
    @position = Position.find(params[:id])

    respond_to do |format|
      format.json { render json: @position }
    end
  end

  # GET /positions/get_last
  def get_last
    taxi_id = params[:taxi_id]
    taxi = Taxi.find(taxi_id)
    last_pos = taxi.get_last_position
    render_as_json last_pos
  rescue NoPositionError => e
    render_error(e)
  end


  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new()
    @position.taxi_id = params[:taxi_id]
    @position.latitude = params[:latitude]
    @position.longitude = params[:longitude]

    respond_to do |format|
      if @position.save
        format.json { render json: @position, status: :created, location: @position }
      else
        format.json { render json: render_error(@position.errors) }
      end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.json
  def update
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position])
        format.json { head :no_content }
      else
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    Position.delete(params[:id])

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  #se hace de los datos
  # PUT /positions/reset.json
  def reset
    num_deleted = Position.delete_all
    respond_to do |format|
      format.json {render json: num_deleted}
    end

  end

end
