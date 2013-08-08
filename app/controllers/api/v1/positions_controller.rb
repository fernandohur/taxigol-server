module Api
	module V1
		class PositionsController < ApiController

			respond_to :json

			# GET /positions
			def index
				respond_with Position.all
			end

			# GET /positions/:id
			def show
				respond_with Position.find(params[:id])
			end

			# POST /positions
			def create
				respond_with Position.create(params[:position])
			end

			# PUT /positions/:id
			def update
				respond_with Position.update(params[:id],params[:position])
			end

			# DELETE /positions/:id
			def destroy
				respond_with Position.destroy(params[:id])
			end

		end
	end
end