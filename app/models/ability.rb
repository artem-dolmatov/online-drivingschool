class Ability
	include CanCan::Ability

	def initialize(user)

		alias_action :index, :create, :read, :update, :destroy, :delete, :to => :icrud
		alias_action :create, :read, :update, :destroy, :delete, :to => :crud
		alias_action :create, :read, :update, :to => :cru
		alias_action :read, :update, :destroy, :delete, :to => :rud
		alias_action :index, :create, :update, :to => :icu
		alias_action :create, :update, :to => :cu
		alias_action :index, :update, :to => :iu
		alias_action :create, :read, :to => :cr
		alias_action :read, :update, :to => :ru
		alias_action :index, :read, :to => :ir

		user ||= User.new # guest user (not logged in)

		if user.role? :admin # ADMIN
			can :manage, :all
			can [:icrud], :admin_users

		elsif user.role? :student # STUDENT

			can :index, :admin_dashboard
			can [:update], User, :id => user.id
			can [:create, :new], Feedback
			can [:index], Post

		elsif user.role? :demo # DEMO

			can :index, :admin_dashboard
			can [:update], User, :id => user.id
			can [:create, :new], Feedback
			can [:index], Post

		elsif user.role? :methodist # METHODIST

			can :index, :admin_dashboard
			# can [:update], User, :id => user.id
			can :icrud, User

		end
	end

end
