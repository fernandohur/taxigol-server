module ApplicationHelper

	#
	# helper method to render a datetime object using the common/timeago partial
	#
	def render_date(date)
		render :partial=>"common/timeago",:locals=>{:date=>date}
	end

	#
	# helper method to pretty print a service's state using the
	# common/state partial
	#
	def render_state_label(service)
		render :partial=>"common/state",:locals=>{:service=>service}
	end

end
