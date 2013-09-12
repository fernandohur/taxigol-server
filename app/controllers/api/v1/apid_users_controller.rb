module Api
  module V1
    class ApidUsersController < ApiController

      respond_to :json

      # GET /apid_users
      # GET /apid_users.json
      def index
        respond_with ApidUser.all
      end

      # GET /apid_users/1
      # GET /apid_users/1.json
      def show
        respond_with ApidUser.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        respond_with nil
      end

      # POST /apid_users
      # POST /apid_users.json
      def create
        respond_with ApidUser.create_or_uptade(params[:apid_user])
      end

      # PUT /apid_users/1
      # PUT /apid_users/1.json
      def update
        respond_with ApidUser.update(params[:id], params[:apid_user])
      rescue ActiveRecord::RecordNotFound
        respond_with ApidUser::StateChangeError
      end

      # DELETE /apid_users/1
      # DELETE /apid_users/1.json
      def destroy
        respond_with ApidUser.find(params[:id])
      end
    end
  end
end

