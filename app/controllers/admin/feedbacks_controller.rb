module Admin
	class FeedbacksController < AdminController
		before_action :set_feedback, only: [:edit, :update, :destroy]

		# gem cancan
		authorize_resource

		# ====================
		#        INDEX
		# ====================
		def index
			@feedbacks = Feedback.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@feedback = Feedback.new
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
			@feedback = Feedback.new(feedback_params)

			# save
			@feedback.user = current_user
			if @feedback.save
				respond = true
			else
				respond = false
			end

			# redirect

			# redirect
			if current_user.role? :student
				redirect = new_admin_feedback_path
			else
				redirect = admin_feedbacks_path
			end

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Заявка успешно создана'}
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
			if @feedback.update(feedback_params)
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_feedbacks_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @feedback.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@feedback.destroy

			# redirect
			redirect = admin_feedbacks_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_feedback
				@feedback = Feedback.find(params[:id])
			end

			def feedback_params
				params_str = ''
				fields = Feedback.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:feedback].permit(#{params_str})")
			end
	end
end