module Api
	module V1
		class TaxisController < ApiController

			respond_to :json

			# GET /taxis
			def index
				respond_with Taxi.all
			end

			# GET /taxis/:id
			def show
				respond_with Taxi.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				respond_with nil
			end

			# POST /taxis
			def create
				respond_with Taxi.create(params[:taxi])
			end

			# PUT /taxis/:id
			def update
				respond_with Taxi.update(params[:id],params[:taxi])
			rescue ActiveRecord::RecordNotFound
				respond_with Taxi::StateChangeError
			end

			# DELETE /taxis/:id
			def destroy
				respond_with Taxi.destroy(params[:id])
			end

		end
	end
end