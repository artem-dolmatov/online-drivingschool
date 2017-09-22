class ApiController < ActionController::API
	# 200 - :ok
	# 204 - :no_content
	# 400 - :bad_request
	# 403 - :forbidden
	# 401 - :unauthorized
	# 404 - :not_found
	# 410 - :gone
	# 422 - :unprocessable_entity
	# 500 - :internal_server_error
	include ActionController::ImplicitRender

	def check_token
		@token = UserAuthToken.where({auth_token: params[:token]}).first

		if @token.nil?
			@message = 'ошибка авторизации'
			render template: 'api/v1/errors/unauthorized', status: :unauthorized
		end
	end
end