module Admin
	class EntityFileController < AdminController
		before_action :set_entity_file, only: [:edit, :update, :destroy]

		# ====================
		#        NEW
		# ====================
		def new
			@entity_file = EntityFile.new
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
			@entity_file = EntityFile.new(entity_file_params)

			respond_to do |format|
				if @entity_file.save
					format.json { head :no_content }
				else
					format.json { head :no_content }
				end
			end
		end

		# ====================
		#       UPDATE
		# ====================
		def update

			respond_to do |format|
				if @entity_file.update(entity_file_params)
					format.json { head :no_content }
				else
					format.json { render json: @user.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@entity_file.destroy
			respond_to do |format|
				format.json { head :no_content }
			end
		end

		def load

			result = []
			params[:field_names].each do |field|
				field_name = field.to_s.underscore.downcase
				files = params[eval(":#{params[:entity].to_s.underscore.downcase}_file")][eval(":#{field_name}")]


				if (params[eval(":#{field_name}")][:multiple] == 'true') && (files.class.name.to_s == 'Array')

					if files.count > 0
						files.each_with_index do |file, index|
							unless file.kind_of?(String)
								file = EntityFile.create({:entity => params[:entity],
								                          :entity_id => params[:entity_id],
								                          :name => eval(":#{field_name}"),
								                          :file => file,
								                          :main => 0,
								                          :title => file.original_filename,
								                          :desc => '',
								                          :content_type => file.content_type,
								                          :original_filename => file.original_filename,
								                          :size => file.size,
								                          :user_id => current_user.id})
								result[index] = file
							end
						end
					end
				end

				if (params[eval(":#{field_name}")][:multiple] == 'false') && (files.class.name.to_s == 'ActionDispatch::Http::UploadedFile')
					EntityFile.where(:entity => params[:entity], :entity_id => params[:entity_id], :name => eval(":#{field_name}")).destroy_all


					file = EntityFile.create({:entity => params[:entity],
					                          :entity_id => params[:entity_id],
					                          :name => eval(":#{field_name}"),
					                          :file => files,
					                          :main => 0,
					                          :title => files.original_filename,
					                          :desc => '',
					                          :content_type => files.content_type,
					                          :original_filename => files.original_filename,
					                          :size => files.size,
					                          :user_id => current_user.id})
					result[0] = file
				end
			end


			respond_to do |format|
				format.js {render :json => {result: 'success', files: result}}
			end
		end

		def remove
			file = EntityFile.where(:id => params[:id]).first

			file.destroy unless file.nil?


			respond_to do |format|
				format.js {render :json => {result: 'success'}}
			end

		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_entity_file
				@entity_file = EntityFile.find(params[:id])
			end

			def entity_file_params
				params[:entity_file].permit(:entity, :entity_id, :file, :main, :title, :desc, :user_id)
			end
	end
end
