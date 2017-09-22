module AdminBase
	extend ActiveSupport::Concern

	included do
		class_attribute :table_props
		class_attribute :form_fields
		class_attribute :signatures
	end
end
