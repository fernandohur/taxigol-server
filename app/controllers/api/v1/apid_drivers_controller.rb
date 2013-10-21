module Api
  module V1
    class ApidDriversController < ApiController

      respond_to :json

      # GET /apid_drivers
      # GET /apid_drivers.json
      def index
        respond_with ApidDriver.all
      end

      # GET /apid_drivers/1
      # GET /apid_drivers/1.json
      def show
        respond_with ApidDriver.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        respond_with nil
      end

      # POST /apid_drivers
      # POST /apid_drivers.json
      def create
        respond_with :api,:v1, ApidDriver.create_or_update(params[:apid_driver])
      end

      # PUT /apid_drivers/1
      # PUT /apid_drivers/1.json
      def update
        respond_with ApidDrive.update(params[:id], params[:apid_driver])
      rescue ActiveRecord::RecordNotFound
        respond_with ApidDrive::StateChangeError
      end

      # DELETE /apid_drivers/1
      # DELETE /apid_drivers/1.json
      def destroy
        respond_with ApidDrive.find(params[:id])
      end
    end
  end
end

