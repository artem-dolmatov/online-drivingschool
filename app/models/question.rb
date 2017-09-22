class Question < ActiveRecord::Base

	belongs_to :topic
	has_many :answers, dependent: :destroy

	has_many :edu_categories, through: :questions_edu_categories
	has_many :questions_edu_categories

	include AdminBase

	# signatures
	self.signatures = {
			create_element: 'Создание вопроса',
			edit_element: 'Редактирование вопроса',
			add_element: 'Добавить вопрос',
			elements: 'Вопросы',
			list_elements: 'Список вопросов'
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
								name: 'Тема',
								machine: 'topic.name unless datum.topic.nil?',
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
										icon: ''
								},
								roles: []
						}, {
								name: 'Группа вопроса',
								machine: 'group',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}]

	# field of form
	self.form_fields = [{
								name: 'Категория обучения',
								machine: 'edu_categories',
								type: 'select',
								template: 'multiple',
								items: 'EduCategory.all.map{ |category| [category.name, category.id] }',
								options: {
										prompt: 'Выберите',
										actions: [],
										multiple: true,
								},
								validates: {
										rules: {},
										messages: {},
										actions: []
								},
								roles: []
						}, {
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
								name: 'Тема',
								machine: 'topic_id',
								type: 'select',
								template: 'default',
								items: 'Topic.all.order(weight: :asc).each_with_index.map { |topic, index| [topic.name_with_number(index + 1), topic.id] }',
								options: {
										prompt: 'Выберите',
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Тема обязательно для заполнения'
										},
										actions: []
								},
								roles: [:admin]
						}, {
								name: 'Группа вопроса',
								machine: 'group',
								type: 'select',
								template: 'default',
								items: '[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]',
								options: {
										prompt: 'Выберите',
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
						}]

	def table_row_color
	end
end
