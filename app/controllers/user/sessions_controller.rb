class User::SessionsController < Devise::SessionsController
	layout 'admin/external_page'
	respond_to :html, :json

	# GET /resource/sign_in
	# def new
	# 	super
	# end

	# POST /resource/sign_in
	def create
		user = User.find_for_database_authentication(email: params[:user][:email])

		if !user.nil? && user.valid_password?(params[:user][:password])
			sign_in :user, user
			respond = true
		else
			set_flash_message(:alert, :invalid)
			respond = false
		end

		respond_to do |format|
			if respond
				format.html { redirect_to after_sign_in_path_for(resource) }
				format.json { render json: {url: after_sign_in_path_for(resource)} }
			else
				format.html { redirect_to after_sign_out_path_for(resource) }
				format.json { render json: flash[:alert], status: :unauthorized }
			end
		end
	end

	# DELETE /resource/sign_out
	# def destroy
	#   super
	# end

	# protected

	# If you have extra params to permit, append them to the sanitizer.
	# def configure_sign_in_params
	#   devise_parameter_sanitizer.for(:sign_in) << :attribute
	# end

	protected
	def after_sign_in_path_for(user)
		admin_root_path
	end

	def after_sign_out_path_for(user)
		new_user_session_path
	end
	def invalid_login_attempt
		set_flash_message(:alert, :invalid)
		render json: flash[:alert], status: 401
	end
end
