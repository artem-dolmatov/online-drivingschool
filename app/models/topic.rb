class Topic < ActiveRecord::Base

	has_many :questions, dependent: :destroy
	has_many :user_topics, dependent: :destroy

	include AdminBase

	# signatures
	self.signatures = {
			create_element: 'Создание тему',
			edit_element: 'Редактирование тему',
			add_element: 'Добавить тему',
			elements: 'Темы',
			list_elements: 'Список тем'
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
								name: 'Вес',
								machine: 'weight',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
										show_in_modal: true
								},
								roles: []
						}, {
								name: 'Это экзамен?',
								machine: 'exam == 1 ? "Да" : "--" ',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
										show_in_modal: true
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
								name: 'Изображение',
								machine: 'image',
								type: 'file',
								template: 'entity_files',
								options: {
										actions: [],
										placeholder: 'Выберите файл',
										multiple: false
								},
								validates: {
										rules: {},
										messages: {},
										actions: []
								},
								roles: []
						}, {
								name: 'Лекция',
								machine: 'video',
								type: 'file',
								template: 'entity_files',
								options: {
										actions: [],
										placeholder: 'Выберите файл',
										multiple: false
								},
								validates: {
										rules: {},
										messages: {},
										actions: []
								},
								roles: []
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
								name: 'Вес',
								machine: 'weight',
								type: 'text',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true, digits: true},
										messages: {
												required: 'Поле Вес обязательно для заполнения',
												digits: 'Вес должен быть целым числом'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Это экзамен?',
								machine: 'exam',
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

	def next
		self.class.where("weight > ? AND exam = ? AND ticket = ?", weight, 0, 0).order(weight: :asc).first
	end

	def previous
		self.class.where("weight < ? AND exam = ? AND ticket = ?", weight, 0, 0).order(weight: :asc).last
	end

	def name_with_number(index)
		"#{index}. #{self.name}"
	end

	def is_last?
		# raise
		self == self.class.where(exam: 0, ticket: 0).order(weight: :asc).last
	end
end
