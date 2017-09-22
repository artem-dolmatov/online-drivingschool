class Answer < ActiveRecord::Base

	belongs_to :question

	include AdminBase

	# signatures
	self.signatures = {
			create_element: 'Создание ответа',
			edit_element: 'Редактирование ответа',
			add_element: 'Добавить ответ',
			elements: 'Ответы',
			list_elements: 'Список ответов'
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
						}, {
								name: 'Вопрос',
								machine: 'question.try(:name)',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}, {
								name: 'Тема',
								machine: 'try(:question).try(:topic).try(:name)',
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
						}, {
								name: 'Вопрос',
								machine: 'question_id',
								type: 'select',
								template: 'default',
								items: 'Question.all.map{ |question| [question.name, question.id] }',
								options: {
										prompt: 'Выберите',
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Вопрос обязательно для заполнения'
										},
										actions: []
								},
								roles: [:admin]
						}, {
								name: 'Описание',
								machine: 'desc',
								type: 'textarea',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {},
										messages: {},
										actions: []
								},
								roles: []
						}, {
								name: 'Правильный ответ?',
								machine: 'correct',
								type: 'logical',
								template: 'toggle',
								options: {
										actions: [],
										true: 'ДА',
										false: 'НЕТ'
								},
								validates: {
										rules: {},
										messages: {},
										actions: []
								},
								roles: []
						}]

	def table_row_color
	end
end
