module Api
  module V1
    class TokensController < ApiController

      respond_to :json

      # GET /tokens
      def index
        respond_with Token.all
      end

      # GET /tokens/:id
      def show
        respond_with Token.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        respond_with nil
      end

      # POST /tokens
      def create
        respond_with Token.create(params[:token], params[:company_name])
      end

      # PUT /tokens/:id
      def update
        resp = Token.update(params[:id],params[:token])
        render json: resp
      rescue ActiveRecord::RecordNotFound
        respond_with render_error("Error","No se encontro el token")
      end

      # DELETE /tokens/:id
      def destroy
        respond_with Token.destroy(params[:id])
      end

      def validate
        value = params[:value]
        company = params[:company]
        respond_with Token.validate(company, value)
      end

    end
  end
end

