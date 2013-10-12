module Api
	module V1
		class CompaniesController < ApiController

			respond_to :json

			# GET /companies
			def index
				respond_with Company.all
			end

			# GET /companies/:id
			def show
				respond_with Company.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				respond_with nil
			end

			# POST /companies
			def create
				respond_with Company.create(params[:company])
			end

			# PUT /companies/:id
			def update
				respond_with Company.update(params[:id],params[:company])
			rescue ActiveRecord::RecordNotFound
				respond_with Company::StateChangeError
			end

			# DELETE /companies/:id
			def destroy
				respond_with Company.destroy(params[:id])
			end

		end
	end
end