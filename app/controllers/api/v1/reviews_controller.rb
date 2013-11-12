module Api
  module V1
    class ReviewsController < ApiController

      # default and only representation is json
      # cool kids don't use xml :)
      respond_to :json

      #
      # Returns all services
      #
      # @method 	GET
      # @path 	/reviews
      # @params
      # @return a json array of class Review similar to the following
      # [
      # 	{
      # 		comment: "direccion de prueba",
      # 		created_at: "2013-08-27T20:50:50Z",
      # 		id: 122,
      #     user_id: null,
      # 		driver_id: null,
      # 		service_id: 12,
      # 		updated_at: "2013-08-27T20:50:50Z",
      # 	},
      # 	...
      # ]
      def index
        respond_with Review.all
      end

      #
      # Returns a single Review given an id as parameters
      # @method GET
      # @path /reviews/:id
      # @param none
      # @return a json encoded Service
      #
      def show
        respond_with Review.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        respond_with nil
      end

      #
      # Returns a single Review given an id as parameters
      # @method POST
      # @path /reviews
      # @param a json representation of a Review with the parameters set
      # Example:
      # 	{
      # 		comment: "direccion de prueba",
      # 		created_at: "2013-08-27T20:50:50Z",
      # 		id: 122,
      #     user_id: null,
      # 		driver_id: null,
      # 		service_id: 12,
      # 		updated_at: "2013-08-27T20:50:50Z",
      #	}
      # @return the created review as a json object
      #
      def create
        respond_with :api,:v1, Review.create(params[:review])
      end

      # @see {@link create}
      # @method POST
      # @para
      def update
        resp = Review.update(params[:id],params[:review])
        render json: resp
      rescue ActiveRecord::RecordNotFound, Service::StateChangeError => e
        render_exception(e)
      end

      # DELETE /reviews/:id
      def destroy
        respond_with Review.destroy(params[:id])
      end
    end
  end
end
