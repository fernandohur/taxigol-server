#
# Restful controller that allows CRUD for Users
#
module Api
  module V1
    class UsersController < ApiController

      respond_to :json

      # GET /drivers
      # returns all drivers
      def index
        respond_with User.all
      end

      # GET /users/:id
      # return's a users' json representation
      def show
        respond_with User.find(params[:id])
      end

      # POST /drivers
      # creates a new driver
      def create
        respond_with User.create(params[:user])
      end

      # PUT /users/:id
      # updates the driver with the specified id
      def update
        respond_with User.update(params[:id],params[:user])
      end

      # DELETE /users/:id
      # deletes the driver with the specified id
      def destroy
        respond_with User.destroy(params[:id])
      end

    end
  end
end