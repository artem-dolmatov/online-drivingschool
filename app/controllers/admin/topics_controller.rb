module Admin
	class TopicsController < AdminController

		include Admin::EntityFiles

		before_action :set_topic, only: [:edit, :update, :destroy]

		# gem cancan
		load_and_authorize_resource
		authorize_resource :class => :admin_topics

		# ====================
		#        INDEX
		# ====================
		def index
			@topics = Topic.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@topic = Topic.new
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
			@topic = Topic.new(topic_params)

			# save
			if @topic.save
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_topics_path

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
			if @topic.update(topic_params)
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_topics_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @topic.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@topic.destroy

			# redirect
			redirect = admin_topics_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_topic
				@topic = Topic.find(params[:id])
			end

			def topic_params
				params_str = ''
				fields = Topic.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:topic].permit(#{params_str})")
			end
	end
end