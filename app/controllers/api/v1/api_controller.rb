
=begin
	
	Base class from which all ApiControllers should extends
	
=end

module Api
	module V1
		class ApiController < ActionController::Base
			
			#
			# @title string representing the error
			# @message string representing the error
			def render_error(title, message)
				respond_with {:error=>title,:message=>message}
			end

			# renders an exception as follows
			# {
			# 	:error=>exception.class.to_s,
			# 	:message=>exception.message 	
			# }
			# @exception an exception instance
			def render_exception(exception)
				render_error(exception.class.to_s, exception.message)
			end

		end
		
	end
	
end