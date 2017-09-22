module Api
	module V1
		class UsersController < ApiController
			include Devise::Controllers::SignInOut
			# include ActionController::StrongParameters

			before_action :check_token, only: [:logout, :allow_notice, :disallow_notice,
			                                   :subscribe_event, :unsubscribe_event,
			                                   :subscribe_event_category, :unsubscribe_event_category]

			api :GET, '/v1/login', 'Авторизация пользователя'
			description 'Данный метод используется для авторизации пользователя'
			error :code => 401, :desc => 'Логин и/или пароль не подходят для авторизации'
			param :email, String, :desc => 'Почта пользователя', :required => true
			param :password, String, :desc => 'Пароль пользователя', :required => true
			param :device, String, :desc => 'ID устройства (уникальный ключ)', :required => true
			param :device_type, String, :desc => 'ОС устройства, возможны 2 значения: android, ios', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/login?email=admin@admin.com&password=qwer1234&device=android_v_1234&device_type=android"'
			example '
# ответ
{
	user: {
		id: 1,
		name: "Иванов Иван Иванович",
		email: "admin@admin.com",
		role: {
			id: 1,
			name: "user"
		},
		token: "ab5f9d108bab40bba9bf4701dba59c83"
	}
}'
			def login
				ok = false
				email, password, device, device_type = params[:email], params[:password], params[:device], params[:device_type]
				if email.present? && password.present? && device
					@user = User.where(email: email.downcase).first
					ok = @user.valid_password?(password) unless @user.nil?
				end

				if ok
					@token = @user.generate_token(device, device_type)
					sign_in @user, store: false
					render status: :ok
				else
					@message = 'ошибка авторизации'
					render template: 'api/v1/errors/unauthorized', status: :unauthorized
				end
			end

			api :GET, '/v1/logout', 'Завершение сессии пользователя'
			description 'Данный метод используется чтобы выйти из приложения'
			error :code => 401, :desc => 'Ошибка авторизации'
			param :token, String, :desc => 'Token авторизованного пользователя', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/logout?token=ab5f9d108bab40bba9bf4701dba59c83"'
			example '
# ответ
{
	message: "Вы успешно вышли"
}'
			def logout
				sign_out @token.user
				@token.destroy
				@message = 'Вы успешно вышли'
				render status: :ok
			end

			api :POST, '/v1/users', 'Регистрация нового пользователя'
			description 'Данный метод используется чтобы зарагистрировать нового пользователя'
			error :code => 422, :desc => 'Обязательные параметры: name, email, password, repeat_password, device ИЛИ такой email уже существует'
			param :name, String, :desc => 'ФИО пользователя', :required => true
			param :email, String, :desc => 'Email пользователя', :required => true
			param :device, String, :desc => 'ID устройства (уникальный ключ)', :required => true
			param :device_type, String, :desc => 'ОС устройства, возможны 2 значения: android, ios', :required => true
			param :password, String, :desc => 'Пароль', :required => true
			param :repeat_password, String, :desc => 'Повторный пароль', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/users?name=test&email=rostixman@supermail.ru&password=qwer1234&repeat_password=qwer1234&device=android_v_123&device_type=android"'
			example '
# ответ
{
	id: 8,
	name: "test",
	email: "rostixman@supermail.ru",
	role: {
		id: 2,
		name: "user"
	},
	token: "97b60ec608950ab7eeff4a2952bb9153"
}'
			def create
				name, email, device, device_type = params[:name], params[:email], params[:device], params[:device_type]
				pass, repeat_pass = params[:password], params[:repeat_password]

				query_params = {}
				query_params[:email] = email.downcase if email
				query_params[:name] = name if name
				query_params[:password] = pass if pass == repeat_pass
				query_params[:user_status_id] = 1

				if name && email && query_params[:password] && device
					@user = User.find_by_email(query_params[:email])

					if @user.nil?
						@user = User.new(query_params)
						@user.user_role_id = UserRole.find_by_name('user').id
						@user.save
						@token = @user.generate_token(device, device_type)
						sign_in @user, store: false
						render template: 'api/v1/users/_show.json', status: :ok
					else
						@message = 'такой email уже существует'
						render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
					end
				else
					@message = 'Обязательные параметры: name, email, password, repeat_password, device, device_type'
					render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
				end
			end

			api :GET, '/v1/users', 'Получить список пользователей (возможен фильтр)'
			description 'Данный метод используется для получения списка пользователей (возможен фильтр)'
			param :id, String, :desc => 'ID пользователя'
			param :email, String, :desc => 'Email пользователя'
			param :token, String, :desc => 'Token авторизованного пользователя'
			param :page, String, :desc => 'Номер страницы'
			param :per_page, String, :desc => 'Количество элементов на странице'
			meta :page => 'Значение по умолчанию 1', :per_page => 'Значение по умолчанию 10'
			formats ['json']
			example '
# запросы
"http://localhost:3000/api/v1/users?id=1"
"http://localhost:3000/api/v1/users?email=admin@admin.com"
"http://localhost:3000/api/v1/users?token=af9276730b262e363e61bc011332fa61"'
			example '
# ответ
{
	users: [
		{
			id: 8,
			name: "test",
			email: "rostixman@supermail.ru",
			role: {
				id: 2,
				name: "user"
			}
		},
		{
			id: 7,
			name: "test",
			email: "rostixman@yandex.ru",
			role: {
				id: 2,
				name: "user"
			}
		}
	],
	count: 2
}'
			def list

				params[:page] = 1 if params[:page].nil?
				params[:per_page] = 10 if params[:per_page].nil?

				query_params = {}
				query_params[:id] = params[:id] if params[:id]
				query_params[:email] = params[:email] if params[:email]
				query_params[:user_status_id] = 1
				query_params[:user_auth_tokens] = {auth_token: params[:token]} if params[:token]
				@token = UserAuthToken.where(auth_token: params[:token]).first if params[:token]

				@users = User.includes(:tokens)
					         .where(query_params)
					         .order(:created_at => :desc)
					         .paginate(:page => params[:page],
					                   :per_page => params[:per_page])
				render status: :ok
			end


			api :GET, '/v1/login/fb', 'Авторизация через Facebook'
			description 'Данный метод используется для авторизации пользователя через Facebook'
			error :code => 500, :desc => 'fb_id != fb_id либо не получилось зарегаться через fb'
			error :code => 422, :desc => 'Один или несколько обязательных параметров отсутствуют: fb_id, fb_token, fb_email, device'
			param :fb_id, String, :desc => 'ID пользователя в Facebook', :required => true
			param :fb_email, String, :desc => 'Email пользователя в Facebook', :required => true
			param :fb_token, String, :desc => 'Token авторизованного пользователя в Facebook', :required => true
			param :device, String, :desc => 'ID устройства (уникальный ключ)', :required => true
			param :device_type, String, :desc => 'ОС устройства, возможны 2 значения: android, ios', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/login/fb?fb_id=1&fb_email=email@email.com&fb_token=af9276730b262e363e61bc011332fa61&device=android_v_1234&device_type=android"'
			example '
# ответ
{
	user: {
		id: 1,
		name: "Иванов Иван Иванович",
		email: "admin@admin.com",
		role: {
			id: 1,
			name: "user"
		},
		token: "ab5f9d108bab40bba9bf4701dba59c83"
	}
}'
			def fb_login
				id, token, email, device, device_type = params[:fb_id], params[:fb_token], params[:fb_email], params[:device], params[:device_type]

				if id && token && email && device
					@graph = Koala::Facebook::API.new(token)
					fb = @graph.get_object('me')
					@picture = @graph.get_connections('me', 'picture')

					if (fb.include? 'id') && (fb['id'] == id)

						@user = User.where('lower(email) = ?', email.downcase).first
						@user = User.where(:fb_id => id).first if @user.nil?
						if @user.nil?

							pass = SecureRandom.hex(8)
							query_params = {}
							query_params[:email] = email.downcase
							query_params[:name] = fb['name']
							query_params[:password] = pass
							query_params[:fb_id] = id
							query_params[:fb_token] = token
							query_params[:user_status_id] = 1

							@user = User.new(query_params)
							@user.user_role_id = UserRole.find_by_name('user').id

							if @user.save
								# @send = UsersMailer.after_social_registration(email, pass).deliver_later
								@token = @user.generate_token(device, device_type)
								unless @picture.nil?
									avatar = EntityFile.new({entity: 'User', entity_id: @user.id, name: 'avatar'})
									avatar.remote_file_url = @picture.data.url
									avatar.save
								end
								sign_in @user, store: false
								render status: :ok
							else
								@message = 'не получилось зарегаться через fb'
								render template: 'api/v1/errors/internal_server_error', status: :internal_server_error
							end
						else
							@user.fb_id = id
							@user.fb_token = token
							@token = @user.generate_token(device, device_type)
							unless @picture.nil?
								EntityFile.where(entity: 'User', entity_id: @user.id, name: 'avatar').destroy_all
								avatar = EntityFile.create({entity: 'User', entity_id: @user.id, name: 'avatar'})
								avatar.remote_file_url = @picture.data.url
								avatar.save
							end
							sign_in @user, store: false
							render status: :ok
						end
					else
						@message = 'fb_id != fb_id'
						render template: 'api/v1/errors/bad_request', status: :bad_request
					end
				else
					@message = 'Обязательные параметры: fb_id, fb_token, fb_email, device'
					render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
				end
			end

			api :GET, '/v1/login/vk', 'Авторизация через Вконтакте'
			description 'Данный метод используется для авторизации пользователя через Вконтакте'
			error :code => 500, :desc => 'VK_USER_ID != TOKEN_USER_ID или ошибка регистрации через Вконтакте'
			error :code => 422, :desc => 'Один или несколько обязательных параметров отсутствуют: vk_id, vk_token, vk_email, device, device_type'
			param :vk_id, String, :desc => 'ID пользователя Вконтакте', :required => true
			param :vk_email, String, :desc => 'Email пользователя Вконтакте', :required => true
			param :vk_token, String, :desc => 'Token авторизованного пользователя Вконтакте', :required => true
			param :device, String, :desc => 'ID устройства (уникальный ключ)', :required => true
			param :device_type, String, :desc => 'ОС устройства, возможны 2 значения: android, ios', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/login/vk?vk_id=1&vk_email=email@email.com&vk_token=af9276730b262e363e61bc011332fa61&device=android_v_1234&device_type=android"'
			example '
# ответ
{
	user: {
		id: 1,
		name: "Иванов Иван Иванович",
		email: "admin@admin.com",
		role: {
			id: 1,
			name: "user"
		},
		token: "ab5f9d108bab40bba9bf4701dba59c83"
	}
}'
			def vk_login
				id, token, email, device, device_type = params[:vk_id], params[:vk_token], params[:vk_email], params[:device], params[:device_type]
				client_id = '5280816'
				client_secret = 'Ij0hTsO0BOLRoxxA06gd'

				if id && token && email && device

					url_get_access_token = "https://oauth.vk.com/access_token?client_id=#{client_id}&client_secret=#{client_secret}&v=5.34&grant_type=client_credentials"
					c = Curl::Easy.perform(url_get_access_token)
					access_token = JSON.parse(c.body_str)['access_token']

					url_check_access_token = "https://api.vk.com/method/secure.checkToken?token=#{token}&client_secret=#{client_secret}&access_token=#{access_token}"
					c = Curl::Easy.perform(url_check_access_token)
					result = JSON.parse(c.body_str)
					if (result.include? 'response') && (id.to_i == result['response']['user_id'].to_i)

						@user = User.where('lower(email) = ?', email.downcase).first
						@user = User.where(:vk_id => id).first if @user.nil?
						@vk = VkontakteApi::Client.new(token)
						@vk_user = @vk.users.get(uid: id, fields: [:first_name, :last_name, :photo_max])

						if @user.nil?
							pass = SecureRandom.hex(8)
							query_params = {}
							query_params[:email] = email.downcase
							query_params[:name] = "#{@vk_user.first.first_name} #{@vk_user.first.last_name}"
							query_params[:password] = pass
							query_params[:vk_id] = id
							query_params[:vk_token] = token
							query_params[:user_status_id] = 1

							@user = User.new(query_params)
							@user.user_role_id = UserRole.find_by_name('user').id

							if @user.save
								# @send = UsersMailer.after_social_registration(email, pass).deliver_later
								unless @vk_user.first.photo_max.nil?
									avatar = EntityFile.new({entity: 'User', entity_id: @user.id, name: 'avatar'})
									avatar.remote_file_url = @vk_user.first.photo_max
									avatar.save
								end
								@token = @user.generate_token(device, device_type)
								sign_in @user, store: false
								render status: :ok
							else
								@message = 'не получилось зарегаться через vk'
								render template: 'api/v1/errors/internal_server_error', status: :internal_server_error
							end
						else
							@user.vk_id = id
							@user.vk_token = token
							unless @vk_user.first.photo_max.nil?
								EntityFile.where(entity: 'User', entity_id: @user.id, name: 'avatar').destroy_all
								avatar = EntityFile.create({entity: 'User', entity_id: @user.id, name: 'avatar'})
								avatar.remote_file_url = @vk_user.first.photo_max
								avatar.save
							end
							@token = @user.generate_token(device, device_type)
							sign_in @user, store:false
							render status: :ok
						end
					elsif result.include? 'error'
						@message = result['error']['error_code'].to_s + ' ' + result['error']['error_msg'].to_s
						render template: 'api/v1/errors/bad_request', status: :bad_request
					elsif id.to_i != result['response']['user_id'].to_i
						@message = 'VK_USER_ID != TOKEN_USER_ID'
						render template: 'api/v1/errors/bad_request', status: :bad_request
					end
				else
					@message = 'Обязательные параметры vk_id, vk_token, vk_email, device, device_type'
					render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
				end
			end

			api :GET, '/v1/subscribe/event', 'Подписка на мероприятие'
			description 'Данный метод используется для подписки на мероприятие'
			error :code => 401, :desc => 'Ошибка авторизации'
			error :code => 422, :desc => 'Один или несколько обязательных параметров отсутствуют: event_id'
			param :token, String, :desc => 'Token авторизованного пользователя', :required => true
			param :event_id, String, :desc => 'ID мероприятия', :required => true
			meta :respond => 'Метод создает либо находит запись'
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/subscribe/event?event_id=2&token=af9276730b262e363e61bc011332fa61"'
			example '
# ответ
{
	id: 2,
	name: "12341234"
}'
			def subscribe_event

				if params[:event_id]
					query_params = {}
					query_params[:user_id] = @token.user.id
					query_params[:event_id] = params[:event_id]

					@subscribe = UsersEvent.find_or_create_by(query_params)
					render template: 'api/v1/subscribe/subscribe_event.json',status: :ok
				else
					@message = 'Обязательные параметры: event_id'
					render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
				end
			end

			api :GET, '/v1/unsubscribe/event', 'Отписки от мероприятия'
			description 'Данный метод используется для отписки от мероприятия'
			error :code => 401, :desc => 'Ошибка авторизации'
			param :token, String, :desc => 'Token авторизованного пользователя', :required => true
			param :event_id, String, :desc => 'ID мероприятия', :required => true
			meta :respond => 'Метод создает либо находит запись'
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/unsubscribe/event?event_id=2&token=af9276730b262e363e61bc011332fa61"'
			example '
# ответ
{
	message: "Вы успешно отписались"
}'
			def unsubscribe_event

				if params[:event_id]
					query_params = {}
					query_params[:user_id] = @token.user.id
					query_params[:event_id] = params[:event_id]
					UsersEvent.delete_all(query_params)

					@message = 'Вы успешно отписались'

					render template: 'api/v1/subscribe/unsubscribe_event.json',status: :ok
				else
					@message = 'Обязательные параметры: user_id, event_id'
					render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
				end
			end

			api :GET, '/v1/subscribe/category', 'Подписка на категорию'
			description 'Данный метод используется для подписки на категорию'
			error :code => 401, :desc => 'Ошибка авторизации'
			param :token, String, :desc => 'Token авторизованного пользователя', :required => true
			param :category_id, String, :desc => 'ID категории', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/subscribe/category?category_id=2&token=af9276730b262e363e61bc011332fa61"'
			example '
# ответ
{
	id: 2,
	name: "12341234"
}'
			def subscribe_event_category

				if params[:category_id]
					query_params = {}
					query_params[:user_id] = @token.user.id
					query_params[:event_category_id] = params[:category_id]

					@subscribe = UsersEventCategory.find_or_create_by(query_params)
					render template: 'api/v1/subscribe/subscribe_event_category.json',status: :ok
				else
					@message = 'Обязательные параметры: category_id'
					render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
				end
			end

			api :GET, '/v1/unsubscribe/category', 'Отписка от категории'
			description 'Данный метод используется для отписки от категории'
			error :code => 401, :desc => 'Ошибка авторизации'
			error :code => 422, :desc => 'Один или несколько обязательных параметров отсутствуют: category_id'
			param :category_id, String, :desc => 'ID категории', :required => true
			param :token, String, :desc => 'Token авторизованного пользователя', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/unsubscribe/category?category_id=2&token=af9276730b262e363e61bc011332fa61"'
			example '
# ответ
{
	message: "Вы успешно отписались"
}'
			def unsubscribe_event_category

				if params[:category_id]
					query_params = {}
					query_params[:user_id] = @token.user.id
					query_params[:event_category_id] = params[:category_id]

					@message = 'Вы успешно отписались'

					@subscribe = UsersEventCategory.delete_all(query_params)
					render template: 'api/v1/subscribe/unsubscribe_event_category.json', status: :ok
				else
					@message = 'Обязательные параметры: category_id'
					render template: 'api/v1/errors/unprocessable_entity', status: :unprocessable_entity
				end
			end

			api :GET, '/v1/notice/allow', 'Подписаться на пуши'
			description 'Данный метод используется чтобы подписаться на пуши'
			error :code => 401, :desc => 'Ошибка авторизации'
			param :token, String, :desc => 'Token авторизованного пользователя', :required => true
			param :device_token, String, :desc => 'Token для пушей', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/notice/allow?token=af9276730b262e363e61bc011332fa61&device_token=..."'
			example '
# ответ
{
	message: "Вы успешно подписались на пуши"
}'
			def allow_notice
				@token.notify = 1
				@token.device_token = params[:device_token]
				@token.save
				@message = 'Вы успешно подписались на пуши'
				render template: 'api/v1/notice/allow.json', status: :ok
			end

			api :GET, '/v1/notice/disallow', 'Подписаться на пуши'
			description 'Данный метод используется чтобы подписаться на пуши'
			error :code => 401, :desc => 'Ошибка авторизации'
			param :token, String, :desc => 'Token авторизованного пользователя', :required => true
			formats ['json']
			example '
# запрос
"http://localhost:3000/api/v1/notice/disallow?token=af9276730b262e363e61bc011332fa61"'
			example '
# ответ
{
	message: "Вы успешно отписались от пушей"
}'
			def disallow_notice
				@token.notify = 0
				@token.device_token = ''
				@token.save
				@message = 'Вы успешно отписались от пушей'
				render template: 'api/v1/notice/disallow.json', status: :ok
			end
		end
	end
end
