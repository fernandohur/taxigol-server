module Api
	module V1
		class PositionsController < ApiController

			respond_to :json

			# @deprecated
			# GET /positions/:id
			def show
				respond_with Position.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				respond_with nil
			end

			# GET /positions/last/?taxi_id={taxi id}
			def last
				raise RuntimeError, "unsupported operation (for now)"
			end

			# POST /positions
			def create
				respond_with Position.create(params[:position])
			end

		end
	end
end