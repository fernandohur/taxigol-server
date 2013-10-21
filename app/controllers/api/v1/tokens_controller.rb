module Api
  module V1
    class TokensController < ApplicationController

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
        respond_with Token.create(params[:token])
      end

      # PUT /tokens/:id
      def update
        respond_with Token.update(params[:id],params[:token])
      rescue ActiveRecord::RecordNotFound
        respond_with Token::StateChangeError
      end

      # DELETE /tokens/:id
      def destroy
        respond_with Token.destroy(params[:id])
      end

    end
  end
end

