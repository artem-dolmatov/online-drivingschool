module Admin
	class UserRolesController < AdminController
		before_action :set_user_role, only: [:edit, :update, :destroy]

		# gem cancan
		authorize_resource

		# ====================
		#        INDEX
		# ====================
		def index
			@user_roles = UserRole.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@user_role = UserRole.new
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
			@user_role = UserRole.new(user_role_params)

			# save
			if @user_role.save
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_user_roles_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно создана'}
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
			if @user_role.update(user_role_params)
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_user_roles_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @user_role.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@user_role.destroy

			# redirect
			redirect = admin_user_roles_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_user_role
				@user_role = UserRole.find(params[:id])
			end

			def user_role_params
				params_str = ''
				fields = UserRole.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:user_role].permit(#{params_str})")
			end
	end
end