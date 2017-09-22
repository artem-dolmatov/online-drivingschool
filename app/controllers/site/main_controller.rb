module Site
	class MainController < SiteController

	    def index
			redirect_to user_session_path
	    end
	end
end