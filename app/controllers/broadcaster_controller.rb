class BroadcasterController < ApplicationController

  def notify_user
    id_user = params[:user_id]
    message = params[:message]
    User.find(id_user).push_notification(message)
    render_message('broadcast sent successfully')
    rescue => ex
      respond_to do |format|
            format.json { render :json => ex.message, :status => 400 }
      end
  end

end
