class Post < ActiveRecord::Base

	include AdminBase

	# signatures
	self.signatures = {
			create_element: 'Создание материала',
			edit_element: 'Редактирование материала',
			add_element: 'Добавить материал',
			elements: 'Материалы',
			list_elements: 'Список материалов'
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
								name: 'Заголовок',
								machine: 'title',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}, {
								name: 'Текст',
								machine: 'body',
								type: 'textarea',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}]

	# field of form
	self.form_fields = [{
								name: 'Название',
								machine: 'title',
								type: 'text',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Заголовок обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Текст',
								machine: 'body',
								type: 'textarea',
								template: 'summernote',
								options: {
										actions: [],
										toolbar: "[ ['para', ['style']],
											['font', ['bold', 'italic', 'underline', 'clear']],
											['color', ['color']],
											['para', ['ul', 'ol', 'paragraph']],
											['table', ['table']],
											['insert', ['link', 'picture', 'hr']],
											['view', ['fullscreen', 'codeview']],
											['help', ['help']]
											]".html_safe,
										height: 200,
										focus: false
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Текст обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Видео',
								machine: 'video',
								type: 'file',
								template: 'entity_files',
								options: {
										actions: [],
										placeholder: 'Выберите файл',
										multiple: false
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Видео обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}]

	def table_row_color
	end
end
