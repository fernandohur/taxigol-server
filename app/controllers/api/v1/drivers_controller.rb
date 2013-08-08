module Api
	module V1
		class DriversController < ApiController

			respond_to :json

			# GET /drivers
			def index
				respond_with Driver.all
			end

			# GET /drivers/:id
			def show
				respond_with Driver.find(params[:id])
			end

			# POST /drivers
			def create
				respond_with Driver.create(params[:driver])
			end

			# PUT /drivers/:id
			def update
				respond_with Driver.update(params[:id],params[:driver])
			end

			# DELETE /drivers/:id
			def destroy
				respond_with Driver.destroy(params[:id])
			end

		end
	end
end