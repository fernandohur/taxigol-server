module Api
	module V1
		class ServicesController < ApiController

			# default and only representation is json
			# cool kids don't use xml :)
			respond_to :json

			# 
			# Returns all services
			# 
			# @method 	GET
			# @path 	/services
			# @params 
			# @return a json array of class Service similar to the following
			# [
			# 	{
			# 		address: "direccion de prueba",
			# 		created_at: "2013-08-27T20:50:50Z",
			# 		id: 122,
			# 		latitude: 12.5,
			# 		longitude: 5.21,
			# 		service_type: "normal",
			# 		state: "pendiente",
      #     user_id: 1,
			# 		taxi_id: null,
			# 		tip: "",
			# 		updated_at: "2013-08-27T20:50:50Z",
			# 		verification_code: "12"
			# 	},
			# 	...
			# ]
			def index
				respond_with Service.all
			end

			# 
			# Returns a single Service given an id as parameters
			# @method GET 
			# @path /services/:id
			# @param none
			# @return a json encoded Service
			# 
			def show
				respond_with Service.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				respond_with nil
			end

			# 
			# Returns a single Service given an id as parameters
			# @method POST
			# @path /services
			# @param a json representation of a Service with the parameters set
			# Example:
			# 	{
			#	 	"address":"test address",
			#	 	"latitude":4.71341,
			#	 	"longitude":-74.12,
			#		"service_type":"",
			#		"state":"pendiente",
			#		"taxi_id":null,
			# 		"tip":"1234",
			# 		"verification_code":"28"
			#	}
			# @return the created service as a json object
			# 
			def create
				respond_with Service.create(params[:service])
			end

			# @see {@link create}
			# @method POST
			# @para
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