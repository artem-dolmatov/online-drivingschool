module Admin
    class AdminController < ApplicationController

	    before_action :authenticate_user!

	    layout 'admin/application'

		def admin_controller?
			true
		end

	    def base
		    redirect_to admin_dashboard_path
	    end

	    rescue_from CanCan::AccessDenied do |exception|
		    redirect_to admin_root_url, :notice => 'У вас недостаточно прав, чтобы просмотреть данный раздел' #exception.message
	    end
    end
end
