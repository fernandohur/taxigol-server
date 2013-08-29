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

	def render_static_map(service, size_x=300, size_y=300, zoom=13)
		render :partial=>"common/static_map",:locals=>
			{
				:latitude => service.latitude,
				:longitude => service.longitude,
				:size_x => size_x,
				:size_y => size_y,
				:zoom => zoom
			}
	end

end
