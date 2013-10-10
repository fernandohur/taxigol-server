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
			# 
			def last
				respond_with Position.find_last(params[:taxi_id])
			end

			# POST /positions
			def create
        Position.delete_old(position.taxi_id)
				position = Position.create(params[:position])
				respond_with position
			end

		end
	end
end