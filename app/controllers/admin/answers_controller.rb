module Admin
	class AnswersController < AdminController

		include Admin::EntityFiles

		before_action :set_answer, only: [:edit, :update, :destroy]

		# gem cancan
		load_and_authorize_resource
		authorize_resource :class => :admin_answers

		# ====================
		#        INDEX
		# ====================
		def index
			@answers = Answer.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@answer = Answer.new
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
			@answer = Answer.new(answer_params)

			# save
			if @answer.save
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_answers_path

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
			if @answer.update(answer_params)
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_answers_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @answer.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@answer.destroy

			# redirect
			redirect = admin_answers_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_answer
				@answer = Answer.find(params[:id])
			end

			def answer_params
				params_str = ''
				fields = Answer.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:answer].permit(#{params_str})")
			end
	end
end