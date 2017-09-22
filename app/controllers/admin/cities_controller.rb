module Admin
	class CitiesController < AdminController
		before_action :set_city, only: [:edit, :update, :destroy]

		# gem cancan
		authorize_resource

		# ====================
		#        INDEX
		# ====================
		def index
			@cities = City.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@city = City.new
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
			@city = City.new(city_params)

			# save
			if @city.save
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_cities_path

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
			if @city.update(city_params)
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_cities_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @city.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@city.destroy

			# redirect
			redirect = admin_cities_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_city
				@city = City.find(params[:id])
			end

			def city_params
				params_str = ''
				fields = City.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:city].permit(#{params_str})")
			end
	end
end