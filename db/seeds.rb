def firstly
	UserStatus.create([{name: 'Активен'},
	                   {name: 'Не активен'},
	                   {name: 'Заблокирован'}])

	UserRole.create([{name: 'admin', ru_name: 'Администратор'},
	                 {name: 'demo', ru_name: 'Демо'},
	                 {name: 'methodist', ru_name: 'Методист'},
	                 {name: 'student', ru_name: 'Обучающийся'}])

	user = User.new({email: 'rostixman@admin.com',
	                 password: 'VjbsYFEX47gN',
	                 password_confirmation: 'VjbsYFEX47gN',
	                 first_name: 'Ильин',
	                 second_name: 'Ростислав',
	                 last_name: 'Вячеславович',
	                 user_role_id: 1,
	                 user_status_id: 1})
	user.save

end

def create_methodist
	# User.find_by_email('test@test.com').destroy
	user = User.new({email: 'test@test.com',
					 password: 'admin123',
					 password_confirmation: 'admin123',
					 first_name: 'test',
					 second_name: 'methodist',
					 last_name: 'test',
					 user_role_id: UserRole.where(name: 'methodist').first.id,
					 user_status_id: 1})
	user.save
end

def create_topics
	Topic.delete_all
	topics = [{name: 'Общие положения', img: '/demo/topics/img1.jpg', weight: 1, exam: 0},
			  {name: 'Общие обязанности водителей', img: '/demo/topics/img2.jpg', weight: 2, exam: 0},
			  {name: 'Применение специальных сигналов', img: '/demo/topics/img3.jpg', weight: 3, exam: 0},
			  {name: 'Приложение 1. Дорожные знаки', img: '/demo/topics/img4.gif', weight: 4, exam: 0},
			  {name: 'Приложение 2. Дорожная разметка', img: '/demo/topics/img5.gif', weight: 5, exam: 0},
			  {name: 'Сигналы светофора и регулировщика', img: '/demo/topics/img6.jpg', weight: 6, exam: 0}]

	topics.each do |topic|
		t = Topic.create({name: topic[:name], weight: topic[:weight], exam: topic[:exam]})
		EntityFile.create({entity: 'Topic', entity_id: t.id, name: 'image',
						   file: File.open("#{Rails.root}/public#{topic[:img]}"),
						   main: 0, title: topic[:img], original_filename: topic[:img], user_id: 1})
	end
end

def create_example_data
	Topic.destroy_all

	(1..60).each do |ticket|
		topic = Topic.create({name: "тема №#{ticket}", weight: ticket, exam: 0, ticket: 0})

		(1..20).each do |index|

			question = Question.create({name: "Вопрос #{index} к теме №#{ticket}", topic_id: topic.id, weight: index, group: index})

			question.answers.create([{name: "Ответ 1 на вопрос: #{question.name}", correct: 1},
									 {name: "Ответ 2 на вопрос: #{question.name}", correct: 0},
									 {name: "Ответ 3 на вопрос: #{question.name}", correct: 0}])

		end
	end

	topic = Topic.create({name: 'Экзамен', weight: 9999, exam: 1, ticket: 0})

end

def view_all_topics
	UserTopic.destroy_all

	Topic.where(exam: 0).each do |topic|
		UserTopic.create({user_id: 3, topic_id: topic.id, done: 1})
	end
end

def access_for_user
	[12, 13, 14, 15, 16, 17, 18, 19, 20, 21].each do |user_id|
		Topic.where(exam: 0, ticket: 0).order(weight: :asc).each_with_index do |topic, index|
			if index < 36
				UserTopic.create({user_id: user_id, topic_id: topic.id, done: 1})
			end
		end
	end
end

def create_edu_categories
	EduCategory.create([{name: 'AB'},
					   	{name: 'CD'}])
end

def update_existing_questions
	questions = Question.all

	questions.each do |item|
		item.edu_categories << EduCategory.all
	end
end

def full_seed
	# firstly
	# create_topics
	# create_example_data
	# view_all_topics
	# access_for_user
	# create_edu_categories
	update_existing_questions
	# create_methodist
end

full_seed