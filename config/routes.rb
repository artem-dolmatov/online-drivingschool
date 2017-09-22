Rails.application.routes.draw do

	# apipie
	apipie

	# devise
	devise_for :users, controllers: {
		sessions: 'user/sessions',
		registrations: 'user/registrations',
		passwords: 'user/passwords'
	}

	# site
	namespace :site, :path => '' do
		root to: 'main#index'
		# get '/' => 'main#index'
	end

	# admin
	namespace :admin do
		root to: 'admin#base'
		get 'dashboard', to: 'dashboard#index'
		resources :users
		resources :user_roles
		resources :topics
		resources :questions
		resources :answers
		resources :feedbacks
		resources :cities
		resources :posts
		resources :schools

		# ajax
		patch 'file/load' => 'entity_file#load', :as => 'file_load'
		post 'file/remove' => 'entity_file#remove', :as => 'file_remove'

		# student_tests
		get '/student/topics', to: 'student_tests#topics'
		get '/student/topics/:id/lecture', to: 'student_tests#lecture', :as => :student_topic_lecture
		get '/student/topics/:id/questions/', to: 'student_tests#questions', :as => :student_topic_questions

        get '/load_error_topic', to: 'student_tests#load_error_topic'

		post '/student/topics/done',  to: 'student_tests#done'
	end

	# api
	namespace :api, defaults: {format: 'json'} do
		namespace :v1 do
			# user
			get 'users' => 'users#list'
			post 'users' => 'users#create'
			get 'login' => 'users#login'
			get 'logout' => 'users#logout'

			# notice
			get 'notice/allow' => 'users#allow_notice'
			get 'notice/disallow' => 'users#disallow_notice'

			# social
			get 'login/fb' => 'users#fb_login'
			get 'login/vk' => 'users#vk_login'
		end
	end
end
