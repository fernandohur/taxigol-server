module ServicesHelper

	def render_services(services)
		render :partial=> "services/services",:locals=>{:services=>services}
	end

end
