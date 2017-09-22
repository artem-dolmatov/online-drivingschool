module Admin
	class StudentTestsController < AdminController

		before_action :load_topics

		def topics
			@exam = Topic.where(exam: 1).first
		end

		def lecture
			@topic = Topic.where(id: params[:id]).first unless params[:id].nil?
			@topic = @topics.first if current_user.role? :demo
		end

		def questions
			@topic = Topic.where(id: params[:id]).first unless params[:id].nil?
			@topic = @topics.first if current_user.role? :demo
			@exam = Topic.where(exam: 1).first

			users_edu_categories = current_user.edu_category_ids


			# questions_edu_categories = @topic.questions.edu_categories

			@topic_questions = @topic.questions.includes(:questions_edu_categories)
									   .where(questions_edu_categories: {edu_category_id: users_edu_categories})
									   .order(weight: :asc)

			if @topic.try(:exam) == 1

				questions = []
				(1..20).each do |index|
					questions.push(Question.where(group: index).order('RANDOM()').limit(3));
				end

				questions.map{|q| @topic_questions += q}
			end
		end

		def done
			topic_id = params[:topic_id]
			topic = Topic.find(topic_id)
			UserTopic.find_or_create_by({user_id: current_user.id, topic_id: topic_id, done: 1}) if current_user.role? :student


			if topic.exam == 1

			end

			render json: {done: true, exam: topic.exam}
		end

		## callback
		def load_topics
			@topics = Topic.where(exam: 0, ticket: 0).order(weight: :asc)
		end

		def load_error_topic
			incorrect_answer = Answer.find(params[:no_answer])

			@topic = incorrect_answer.question.topic

			# @topic = #Topic.where(id: params[:id]).first unless params[:id].nil?
			# @topic = @topics.first if current_user.role? :demo
			# @exam = Topic.where(exam: 1).first

			@topic_questions = @topic.questions.order('RANDOM()').limit(5)

			render 'admin/student_tests/render_topic.js.erb'

		end
	end
end