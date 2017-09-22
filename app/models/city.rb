class City < ActiveRecord::Base

	include AdminBase

	# signatures
	self.signatures = {
			create_element: 'Создание города',
			edit_element: 'Редактирование города',
			add_element: 'Добавить город',
			elements: 'Города',
			list_elements: 'Список городов'
	}

	# properties of table
	self.table_props = [{
								name: '#',
								machine: 'id',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
										show_in_modal: true
								},
								roles: []
						}, {
								name: 'Название',
								machine: 'name',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}]

	# field of form
	self.form_fields = [{
								name: 'Название',
								machine: 'name',
								type: 'text',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Название обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}]

	def table_row_color
	end
end
