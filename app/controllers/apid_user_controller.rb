class ApidUserController < ApplicationController
  # GET /apid_users
  # GET /apid_users.json
  def index
    @apid_users = ApidUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apid_users }
    end
  end

  # GET /apid_users/1
  # GET /apid_users/1.json
  def show
    @apid_user = ApidUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @apid_user }
    end
  end

  # GET /apid_users/new
  # GET /apid_users/new.json
  def new
    @apid_user = ApidUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @apid_user }
    end
  end

  # GET /apid_users/1/edit
  def edit
    @apid_user = ApidUser.find(params[:id])
  end

  # POST /apid_users
  # POST /apid_users.json
  def create
    @apid_user = ApidUser.get_or_create(params[:apid_user], params[:user_id])
    respond_to do |format|
      if @apid_user.save
        format.json { render json: @apid_user, status: :created, location: @user }
      else
        format.json { render json: render_error(@apid_user.errors) }
      end
    end
  end

  # PUT /apid_users/1
  # PUT /apid_users/1.json
  def update
    @apid_user = ApidUser.find(params[:id])

    respond_to do |format|
      if @apid_user.update_attributes(params[:apid_user])
        format.json { head :no_content }
      else
        format.json { render json: @apid_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apid_users/1
  # DELETE /apid_users/1.json
  def destroy
    @apid_user = ApidUser.find(params[:id])
    @apid_user.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def reset
    num_deleted = ApidUser.delete_all
    respond_to do |format|
      format.json {render json: num_deleted}
    end
  end

end
