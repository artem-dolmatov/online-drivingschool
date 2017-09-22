# encoding: utf-8

class EntityFileUploader < CarrierWave::Uploader::Base

	CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

	include CarrierWave::MiniMagick
	include CarrierWave::MimeTypes

	process :set_content_type
	process :set_meta

    storage :file

	def store_dir
		"uploads/files/#{model.entity.to_s.underscore}/#{mounted_as}/#{model.id}"
	end

	version :preview, :if => Proc.new {|c| c.send(:process_access, %w(All))} do # обрезает
		process resize_to_fill: [403,190]
	end

	version :fit_290x190, :if => Proc.new {|c| c.send(:process_access, %w(User))} do # пропорционально уменьшает
		process resize_to_fit: [290,190]
	end


	def filename
		"#{secure_token(10)}_#{Translit.convert(URI.decode(original_filename), :english)}" if original_filename.present?
	end

	def set_meta
		model.content_type = file.content_type if file.content_type
		model.size = file.size
	end

	private
		def process_access(entities)
			content_types = %w(image/gif image/jpeg image/pjpeg image/png)

			(entities.include?('All') || entities.include?(model.entity)) && content_types.include?(model.content_type)
		end

		def secure_token(length=16)
			var = :"@#{mounted_as}_secure_token"
			model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
		end
end
