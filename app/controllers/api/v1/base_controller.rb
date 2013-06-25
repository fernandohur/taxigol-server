module Api
	module V1
		class BaseController

			respond_to :json

			def render_error(exception)

			end

			def render_json(json)

			end

		end
	end
end