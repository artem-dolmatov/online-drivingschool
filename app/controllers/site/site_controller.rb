module Site
	class SiteController < ApplicationController

	    layout 'site/application'

		def site_controller?
			true
		end

	    # rescue_from CanCan::AccessDenied do |exception|
		 #    redirect_to admin_root_url, :alert => exception.message
	    # end
	end
end