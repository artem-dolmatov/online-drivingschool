module Admin
	class SchoolsController < AdminController
		before_action :set_school, only: [:edit, :update, :destroy]

		# gem cancan
		authorize_resource

		# ====================
		#        INDEX
		# ====================
		def index
			@schools = School.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@school = School.new
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
			@school = School.new(school_params)

			# save
			if @school.save
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_schools_path

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
			if @school.update(school_params)
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_schools_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @school.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@school.destroy

			# redirect
			redirect = admin_schools_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_school
				@school = School.find(params[:id])
			end

			def school_params
				params_str = ''
				fields = School.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:school].permit(#{params_str})")
			end
	end
end