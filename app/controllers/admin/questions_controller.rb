module Admin
	class QuestionsController < AdminController

		include Admin::EntityFiles

		before_action :set_question, only: [:edit, :update, :destroy]

		# gem cancan
		load_and_authorize_resource
		authorize_resource :class => :admin_questions

		# ====================
		#        INDEX
		# ====================
		def index
			@questions = Question.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@question = Question.new
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
			@question = Question.new(question_params)

			# save
			if @question.save
				respond = true

				edu_categories = question_params_multiple[:edu_categories]
				unless edu_categories.nil?
					@question.edu_categories << EduCategory.find(edu_categories.reject(&:empty?))
				end
			else
				respond = false
			end

			# redirect
			redirect = admin_questions_path

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
			if @question.update(question_params)
				respond = true

				edu_categories = question_params_multiple[:edu_categories]
				unless edu_categories.nil?
					@question.edu_categories.destroy_all
					@question.edu_categories << EduCategory.find(edu_categories.reject(&:empty?))
				end
			else
				respond = false
			end

			# redirect
			redirect = admin_questions_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @question.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@question.destroy

			# redirect
			redirect = admin_questions_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_question
				@question = Question.find(params[:id])
			end

			def question_params
				params_str = ''
				fields = Question.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:question].permit(#{params_str})")
			end

			def question_params_multiple
				params[:question].permit(edu_categories: [])
			end
	end
end