module Api
	module V1
		class ServicesController < ApiController

			respond_to :json

			# GET /services
			def index
				respond_with Service.all
			end

			# GET /services/:id
			def show
				respond_with Service.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				respond_with nil
			end

			# POST /services
			def create
				respond_with Service.create(params[:service])
			end

			# PUT /services/:id
			def update
				resp = Service.update(params[:id],params[:service])
				render json: resp
			rescue ActiveRecord::RecordNotFound
				respond_with Service::StateChangeError
			end

			# DELETE /services/:id
			def destroy
				respond_with Service.destroy(params[:id])
			end

		end
	end
end