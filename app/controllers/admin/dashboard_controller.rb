module Admin
	class DashboardController < AdminController
		authorize_resource :class => :admin_dashboard

		def index
			if current_user.role? :methodist
				redirect_to admin_users_path
			end
		end
	end
end
