module Admin
	class PostsController < AdminController

		include Admin::EntityFiles

		before_action :set_post, only: [:edit, :update, :destroy]

		# gem cancan
		authorize_resource

		# ====================
		#        INDEX
		# ====================
		def index
			@posts = Post.all
		end

		# ====================
		#        NEW
		# ====================
		def new
			@post = Post.new
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
			@post = Post.new(post_params)

			# save
			if @post.save
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_posts_path

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
			if @post.update(post_params)
				respond = true
			else
				respond = false
			end

			# redirect
			redirect = admin_posts_path

			respond_to do |format|
				if respond
					format.html { redirect_to redirect, notice: 'Запись успешно обновлена' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @post.errors, status: :unprocessable_entity }
				end
			end
		end

		# ====================
		#       DELETE
		# ====================
		def destroy
			@post.destroy

			# redirect
			redirect = admin_posts_path

			respond_to do |format|
				format.html { redirect_to redirect }
				format.json { head :no_content }
			end
		end

		# ====================
		#       PRIVATE
		# ====================
		private
			def set_post
				@post = Post.find(params[:id])
			end

			def post_params
				params_str = ''
				fields = Post.form_fields
				fields.each_with_index do |attr, index|
					params_str += ":#{attr[:machine]}#{',' if (fields.count-1) != index}" if attr[:template] != 'entity_files'
				end
				eval("params[:post].permit(#{params_str})")
			end
	end
end