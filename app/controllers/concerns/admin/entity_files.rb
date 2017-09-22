module Admin
	module EntityFiles

		def self.included(base)
			base.before_action :clear_images, only: [:new]
			base.after_action :upload_images, only: [:create]
			base.after_action :destroy_images, only: [:destroy]
		end

		def clear_images
			files = EntityFile.where(:entity => controller_name.classify, :entity_id => nil )
			files.destroy_all unless files.nil?
		end

		def upload_images
			error_count = eval("@#{controller_name.classify.underscore.downcase}.errors.count")
			files = params[:files]
			files = EntityFile.where(:id => files[:id]) unless files.nil?

			if error_count > 0
				files.destroy_all unless files.nil?
			else
				files.to_a.each do |file|
					file.entity_id = eval("@#{controller_name.classify.underscore.downcase}.id")
					file.save
				end
			end
		end

		def destroy_images
			files = EntityFile.where(:entity => controller_name.classify, :entity_id => eval("@#{controller_name.classify.underscore.downcase}.id") )
			files.destroy_all unless files.nil?
		end
	end
end
