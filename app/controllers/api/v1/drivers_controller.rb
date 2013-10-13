#
# Restful controller that allows CRUD for Drivers
#
module Api
	module V1
		class DriversController < ApiController

			respond_to :json

			# GET /drivers
			# returns all drivers
			def index
				respond_with Driver.all
			end

			# GET /drivers/auth
			# see {@link Driver} for more details. 
			# returns the driver with the specified username if the credentials match
			# returns nil if not
			def auth
				respond_with Driver.auth(params[:username],params[:password])
			end

			# GET /drivers/:id
			# return's a drivers' json representation
			def show
				respond_with Driver.find(params[:id])
			end

			# POST /drivers
			# creates a new driver
			def create
				respond_with Driver.create(params[:driver])
			end

			# PUT /drivers/:id
			# updates the driver with the specified id
			def update
				respond_with Driver.update(params[:id],params[:driver])
			end

			# DELETE /drivers/:id
			# deletes the driver with the specified id
			def destroy
				respond_with Driver.destroy(params[:id])
      end


      #GET /drivers/:id/companies
      # get the companies of a driver
      def companies
        companies = Driver.find_by_cedula(params[:id]).company
        if companies.size == 0        el
          companies = Array.new
        end
        respond_with companies
      rescue ActiveRecord::RecordNotFound
        respond_with ActiveRecord::RecordNotFound
      end

		end
	end
end