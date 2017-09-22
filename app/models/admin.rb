module Admin
	class Setting < ActiveRecord::Base
		class_attribute :menu

		self.menu = {admin: [],
					 user: []}

		self.menu[:admin] = [{
									 name: 'Меню',
									 link: 'label',
									 options: {
											 class: 'sidebar-label pt20'
									 }
							 }, {
									 name: 'Рабочий стол',
									 link: 'admin_dashboard_path',
									 options: {
											 icon: 'fa fa-home'
									 }
							 }, {
									 name: 'Темы',
									 link: 'admin_topics_path',
									 options: {
											 icon: 'glyphicons glyphicons-show_big_thumbnails'
									 }
							 }, {
									 name: 'Вопросы',
									 link: 'admin_questions_path',
									 options: {
											 icon: 'fa fa-question-circle'
									 }
							 }, {
									 name: 'Ответы',
									 link: 'admin_answers_path',
									 options: {
											 icon: 'fa fa-comments-o'
									 }
							 }, {
									 name: 'Материалы',
									 link: 'admin_posts_path',
									 options: {
											 icon: 'imoon imoon-newspaper'
									 }
							 }, {
									 name: 'Пользователи',
									 link: 'admin_users_path',
									 options: {
											 icon: 'icon-zoom2 icon-users2'
									 }
							 }, {
									 name: 'Сообщения',
									 link: 'admin_feedbacks_path',
									 options: {
											 icon: 'glyphicon glyphicon-comment'
									 }
							 }, {
									 name: 'Справочники',
									 link: 'label',
									 options: {
											 class: 'sidebar-label pt20'
									 }
							 }, {
									 name: 'Роли',
									 link: 'admin_user_roles_path',
									 options: {
											 icon: 'imoon imoon-users'
									 }
							 }, {
									 name: 'Города',
									 link: 'admin_cities_path',
									 options: {
											 icon: 'imoon imoon-map2'
									 }
							 }, {
									 name: 'Автошколы',
									 link: 'admin_schools_path',
									 options: {
											 icon: 'glyphicons glyphicons-cars'
									 }
							 }]

		self.menu[:student] = [{
									   name: 'Меню',
									   link: 'label',
									   options: {
											   class: 'sidebar-label pt20'
									   }
							   }, {
									   name: 'Рабочий стол',
									   link: 'admin_dashboard_path',
									   options: {
											   icon: 'fa fa-home'
									   }
							   }, {
									   name: 'Тесты',
									   link: 'admin_student_topics_path',
									   options: {
											   icon: 'glyphicons glyphicons-show_big_thumbnails'
									   }
							   }, {
									   name: 'Материалы',
									   link: 'admin_posts_path',
									   options: {
											   icon: 'imoon imoon-newspaper'
									   }
							   }, {
									   name: 'Нашли ошибку?',
									   link: 'new_admin_feedback_url',
									   options: {
											   icon: 'fa fa-warning'
									   }
							   }]

		self.menu[:methodist] = [{
										 name: 'Меню',
										 link: 'label',
										 options: {
												 class: 'sidebar-label pt20'
										 }
								 }, {
										 name: 'Обучающиеся',
										 link: 'admin_users_path',
										 options: {
												 icon: 'icon-zoom2 icon-users2'
										 }
								 }]
		self.menu[:demo] = self.menu[:student]
	end
end