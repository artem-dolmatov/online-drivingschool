class QuestionsEduCategory < ActiveRecord::Base
    belongs_to :question, foreign_key: :question_id
    belongs_to :edu_category, foreign_key: :edu_category_id
end
