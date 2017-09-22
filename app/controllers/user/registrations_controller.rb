class User::RegistrationsController < Devise::RegistrationsController
	layout 'admin/registration'

	def new
		super
	end

	def create
		build_resource(sign_up_params)
		resource.status = Status.find(1)
		resource.roles << Role.find_by_name('advertiser')

		resource.save
		yield resource if block_given?

		if resource.persisted?
			sign_up(resource_name, resource)
			respond_with resource, location: advertiser_root_path
		else
			clean_up_passwords resource
			set_minimum_password_length
			respond_with resource
		end
	end

	def update
		super
	end
end