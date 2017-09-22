class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		   :recoverable,              :rememberable,
		   :trackable,                :validatable

	include AdminBase

	belongs_to :role,         :foreign_key => :user_role_id,     class_name: 'UserRole'
	belongs_to :status,       :foreign_key => :user_status_id,   class_name: 'UserStatus'
	belongs_to :city,         :foreign_key => :city_id,   		 class_name: 'City'
	belongs_to :school,       :foreign_key => :school_id,   	 class_name: 'School'

	has_many :tokens, class_name: 'UserAuthToken', :dependent => :delete_all
	has_many :topics, class_name: 'UserTopic', :dependent => :delete_all

	has_many :edu_categories, through: :users_edu_categories
	has_many :users_edu_categories
	# signatures
	self.signatures = {
			create_element: 'Создание пользователя',
			edit_element: 'Редактирование пользователя',
			add_element: 'Добавить пользователя',
			elements: 'Пользователи',
			list_elements: 'Список пользователей'
	}

	# properties of table
	self.table_props = [{
								name: '#',
								machine: 'id',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
										show_in_modal: true,
										prefix_show_in_modal: '<br>#',
										postfix_show_in_modal: ' - '
								},
								roles: []
						},{
								name: 'E-mail',
								machine: 'email',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
										show_in_modal: true,
										prefix_show_in_modal: '',
										postfix_show_in_modal: ''
								},
								roles: []
						}, {
								name: 'Фамилия и имя',
								machine: 'part_name',
								type: 'text',
								template: 'default',
								options: {
										icon: ''
								},
								roles: []
						}, {
								name: 'Город',
								machine: 'city.try(:name)',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
								},
								roles: []
						}, {
								name: 'Автошкола',
								machine: 'school.try(:name)',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
								},
								roles: []
						}, {
								name: 'Телефон',
								machine: 'phone',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
								},
								roles: []
						}, {
								name: 'Дата',
								machine: 'created_at',
								type: 'date',
								template: 'default',
								options: {
										icon: '',
										format: '%d.%m.%Y'
								},
								roles: []
						}, {
								name: 'Прогресс',
								machine: 'current_lecture',
								type: 'text',
								template: 'default',
								options: {
										icon: '',
								},
								roles: []
						}]

	# field of form
	self.form_fields = [{
								name: 'E-mail',
								machine: 'email',
								type: 'text',
								template: 'email',
								options: {
										tooltip_text: 'Пример: example@gmail.com',
										actions: []
								},
								validates: {
										rules: {
												required: true,
												regex: "^[-a-z0-9!#$%&'*+/=?^_`{|}~]+(?:\\.[-a-z0-9!#$%&'*+/=?^_`{|}~]+)*@(?:[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?[.]+)+(?:aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$".html_safe
										},
										messages: {
												required: 'Поле E-mail обязательно для заполнения',
												regex: 'Некорректно указан E-mail'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Пароль',
								machine: 'password',
								type: 'password',
								template: 'default',
								options: {
										tooltip_text: 'Пароль должен быть не менее 8 символов',
										help_text: 'Если не хотите менять пароль, оставьте поле <u>пустым</u>',
										actions: []
								},
								validates: {
										rules: {required: true,  minlength: 8},
										messages: {
												required: 'Поле Пароль обязательно для заполнения',
												minlength: 'Длина пароля должна быть не менее 8 символов',
										},
										actions: ['new']
								},
								roles: []
						}, {
								name: 'Фамилия',
								machine: 'second_name',
								type: 'text',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Фамилия обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Имя',
								machine: 'first_name',
								type: 'text',
								template: 'default',
								options: {
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Имя обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Отчество',
								machine: 'last_name',
								type: 'text',
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
								name: 'Телефон',
								machine: 'phone',
								type: 'text',
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
								name: 'Город',
								machine: 'city_id',
								type: 'select',
								template: 'default',
								items: 'City.all.map{ |city| [city.name, city.id] }',
								options: {
										prompt: 'Выберите',
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Город обязательно для заполнения'
										},
										actions: []
								},
								roles: [:admin]
						},{
								name: 'Автошкола',
								machine: 'school_id',
								type: 'select',
								template: 'default',
								items: 'School.all.map{ |school| [school.school_city, school.id] }',
								options: {
										prompt: 'Выберите',
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Автошкола обязательно для заполнения'
										},
										actions: []
								},
								roles: []
						}, {
								name: 'Статус',
								machine: 'user_status_id',
								type: 'select',
								template: 'default',
								items: 'UserStatus.all.map{ |status| [status.name, status.id] }',
								options: {
										prompt: 'Выберите',
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Статус обязательно для заполнения'
										},
										actions: []
								},
								roles: [:admin]
						}, {
								name: 'Роль',
								machine: 'user_role_id',
								type: 'select',
								template: 'default',
								items: 'UserRole.all.map{ |role| [role.ru_name, role.id] }',
								options: {
										prompt: 'Выберите',
										actions: []
								},
								validates: {
										rules: {required: true},
										messages: {
												required: 'Поле Роль обязательно для заполнения'
										},
										actions: []
								},
								roles: [:admin]
						},
						{
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
						}]

	def is_active?
		self.user_status_id == 1
	end

	def table_row_color
		'danger' if self.user_status_id == 2
		'warning' if self.user_status_id == 3
	end

	def full_name
		name = ''
		name += self.email if (self.first_name == '') && (self.second_name == '') && (self.last_name == '')
		name += " #{self.first_name}" if self.first_name
		name += " #{self.second_name}" if self.second_name
		name += " #{self.last_name}" if self.last_name
		# name += " (#{self.email})" if (self.first_name != '') || (self.second_name != '') || (self.last_name != '')
		name
	end

	def part_name
		name = ''
		name += " #{self.first_name}" if self.first_name
		name += " #{self.second_name}" if self.second_name
		name
	end

	def role?(role)
		self.role.name == role.to_s
	end

	def current_lecture
		topics = self.topics.order(created_at: :asc)
		topic = topics.try(:last).try(:topic)

		if topic.try(:exam) == 1
			result_string = 'Экзамен пройден!'
		else
			name = topic.try(:name)
			result_string = "Последняя тема: #{name}" unless name.nil?
		end

		result_string ||= '--'
		result_string
	end
end
