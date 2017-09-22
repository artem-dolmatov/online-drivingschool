module Admin
	class UsersController < AdminController
		include Admin::EntityFiles

		before_action :set_user, only: [:edit, :update, :destroy]

		# gem cancan
		authorize_resource

		# ====================
		#        INDEX
		# ====================
		def index

			params = {}

			if current_user.role? :methodist
				params[:school_id] = current_user.school_id
				params[:user_role_id] = UserRole.find_by_name('student').id
			end

			@users = User.where(params)
		end

		# ====================
		#        NEW
		# ====================
		def new
			@user = User.new
		end

		# ====================
		#        EDIT
		# ====================
		def edit
		end

		# ====================
		#       CREATE
		# ====================
		def create
			@user = User.new(user_params_create)

			if current_user.role? :methodist
				@user.user_role_id = UserRole.find_by_name('student').id
				@user.user_status_id = UserStatus.find_by_name('Активен').id
				@user.city_id = current_user.city_id
				@user.save
			end

			# save
			if @user.save
				respond = true

				edu_categories = user_params_multiple[:edu_categories]
				unless edu_categories.nil?
					@user.edu_categories << EduCategory.find(edu_categories.reject(&:empty?))
				end
			else
				respond = false
			end

			# redirect
			redirect = admin_users_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: "Пользователь <span class=\"fwb\">#{@user.email}</span> успешно создан"}
					format.json { head :no_content }
				else
					format.html { render action: 'new' }
					format.json { head :no_content }
				end
			end
		end

		# ====================
		#       UPDATE
		# ====================
		def update

			# update
			if @user.update(user_params_update)
				respond = true

				edu_categories = user_params_multiple[:edu_categories]
				unless edu_categories.nil?
					@user.edu_categories.destroy_all
					@user.edu_categories << EduCategory.find(edu_categories.reject(&:empty?))
				end
			else
				respond = false
			end

			# redirect
			if current_user.role? :student
				redirect = edit_admin_user_path(@user.id)
			else
				redirect = admin_users_path
			end

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: "Пользователь <span class=\"fwb\">#{@user.email}</span> успешно обновлен" }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @user.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@user.destroy

			# redirect
			redirect = admin_users_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_user
				@user = User.find(params[:id])
			end

			def user_params_update
				if (!params[:user][:password].nil?) && (params[:user][:password].length > 0)
					params[:user].permit(:email, :first_name, :second_name, :last_name, :user_role_id,
					                     :user_status_id, :password, :phone, :city_id, :school_id)
				else
					params[:user].permit(:email, :first_name, :second_name, :last_name, :user_role_id,
					                     :user_status_id, :personal_data, :phone, :city_id, :school_id)
				end
			end

			def user_params_create
				params[:user].permit(:email, :first_name, :second_name, :last_name, :user_role_id,
				                     :user_status_id, :password, :phone, :city_id, :school_id)
			end


			def user_params_multiple
				params[:user].permit(edu_categories: [])
			end
	end
end