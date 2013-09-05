class BroadcasterController < ApplicationController


	def broadcast
		message = params[:message]
		payload = params[:payload]
		message_sender = MessageSender.new
		if payload == nil || payload.empty?
			message_sender.push_payload(message, {:action => :broadcast})
		else
			message_sender.push_payload(message, MultiJson.load(payload))
		end

		render_message('broadcast sent successfully')

	rescue Exception => e
		render_error(e)
  end

  def notify_user
    id_user = params[:user_id]
    message = params[:message]
    User.find(id_user).push_notification(message)
  end

end
