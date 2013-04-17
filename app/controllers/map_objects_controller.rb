class MapObjectsController < ApplicationController
  # GET /map_objects
  # GET /map_objects.json
  def index

    category = params[:category]

    if category!=nil
      @map_objects = MapObject.get_by_category(category)
    else
      @map_objects = MapObject.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @map_objects }
    end
  end

  # GET /map_objects/1
  # GET /map_objects/1.json
  def show
    @map_object = MapObject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @map_object }
    end
  end

  # GET /map_objects/new
  # GET /map_objects/new.json
  def new
    @map_object = MapObject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @map_object }
    end
  end

  # GET /map_objects/1/edit
  def edit
    @map_object = MapObject.find(params[:id])
  end

  # POST /map_objects
  # POST /map_objects.json
  def create
    @map_object = MapObject.construct(params[:category],params[:latitude],params[:longitude],params[:description])

    respond_to do |format|
      if @map_object.save
        format.html { redirect_to @map_object, notice: 'Map object was successfully created.' }
        format.json { render json: @map_object, status: :created, location: @map_object }
      else
        format.html { render action: "new" }
        format.json { render json: @map_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /map_objects/1
  # PUT /map_objects/1.json
  def update
    @map_object = MapObject.find(params[:id])

    respond_to do |format|
      if @map_object.update_attributes(params[:map_object])
        format.html { redirect_to @map_object, notice: 'Map object was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @map_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /map_objects/1
  # DELETE /map_objects/1.json
  def destroy
    @map_object = MapObject.find(params[:id])
    @map_object.destroy

    respond_to do |format|
      format.html { redirect_to map_objects_url }
      format.json { head :no_content }
    end
  end
end
