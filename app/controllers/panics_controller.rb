class PanicsController < ApplicationController
  # GET /panics
  # GET /panics.json
  def index
    @panics = Panic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @panics }
    end
  end

  # GET /panics/1
  # GET /panics/1.json
  def show
    @panic = Panic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @panic }
    end
  end

  # GET /panics/new
  # GET /panics/new.json
  def new
    @panic = Panic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @panic }
    end
  end

  # GET /panics/1/edit
  def edit
    @panic = Panic.find(params[:id])
  end

  # POST /panics
  # POST /panics.json
  def create
    @panic = Panic.new(params[:panic])

    respond_to do |format|
      if @panic.save
        format.html { redirect_to @panic, notice: 'Panic was successfully created.' }
        format.json { render json: @panic, status: :created, location: @panic }
      else
        format.html { render action: "new" }
        format.json { render json: @panic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /panics/1
  # PUT /panics/1.json
  def update
    @panic = Panic.find(params[:id])

    respond_to do |format|
      if @panic.update_attributes(params[:panic])
        format.html { redirect_to @panic, notice: 'Panic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @panic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panics/1
  # DELETE /panics/1.json
  def destroy
    @panic = Panic.find(params[:id])
    @panic.destroy

    respond_to do |format|
      format.html { redirect_to panics_url }
      format.json { head :no_content }
    end
  end
end
