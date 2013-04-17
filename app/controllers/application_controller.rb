class ApplicationController < ActionController::Base

  def render_error(e)


    json = {:error=>e.class.to_s, :message=>e.message}.to_json

    respond_to do |format|
      format.json {render json: json}
    end

  end

end
