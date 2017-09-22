class UserRole < ActiveRecord::Base

	include AdminBase

	# signatures
	self.signatures = {
		create_element: 'Создание роли',
		edit_element: 'Редактирование роли',
		add_element: 'Добавить роли',
		elements: 'Роли пользователей',
		list_elements: 'Список ролей'
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
		                    name: 'Название (Eng)',
		                    machine: 'name',
		                    type: 'text',
		                    template: 'default',
		                    options: {
			                    icon: ''
		                    },
		                    roles: []
	                    }, {
		                    name: 'Название (Rus)',
		                    machine: 'ru_name',
		                    type: 'text',
		                    template: 'default',
		                    options: {
			                    icon: ''
		                    },
		                    roles: []
	                    }]

	# field of form
	self.form_fields = [{
		                    name: 'Название (Eng)',
		                    machine: 'name',
		                    type: 'text',
		                    template: 'default',
		                    options: {
			                    actions: []
		                    },
		                    validates: {
			                    rules: {required: true},
			                    messages: {
				                    required: 'Поле Название (Eng) обязательно для заполнения'
			                    },
			                    actions: []
		                    },
		                    roles: []
	                    }, {
		                    name: 'Название (Rus)',
		                    machine: 'ru_name',
		                    type: 'text',
		                    template: 'default',
		                    options: {
			                    actions: []
		                    },
		                    validates: {
			                    rules: {required: true},
			                    messages: {
				                    required: 'Поле Название (Rus) обязательно для заполнения'
			                    },
			                    actions: []
		                    },
		                    roles: []
	                    }]

	def table_row_color
	end
end
