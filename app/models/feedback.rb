class Feedback < ActiveRecord::Base
	belongs_to :user

	include AdminBase

	# signatures
	self.signatures = {
			create_element: 'Создание заявки',
			edit_element: 'Редактирование заявки',
			add_element: 'Добавить завяку',
			elements: 'Заявки пользователей',
			list_elements: 'Список заявок'
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
								name: 'Тема',
								machine: 'theme',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}, {
								name: 'Телефон',
								machine: 'phone',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}, {
								name: 'Сообщение',
								machine: 'body',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}, {
								name: 'Пользователь',
								machine: 'user.try(:full_name)',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}]

	# field of form
	self.form_fields = [{
								name: 'Тема',
								machine: 'theme',
								type: 'text',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Тема обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Телефон',
								machine: 'phone',
								type: 'text',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Телефон обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Сообщение',
								machine: 'body',
								type: 'textarea',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Сообщение обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}]

	def table_row_color
	end
end
