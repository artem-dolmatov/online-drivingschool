class EduCategory < ActiveRecord::Base
    include AdminBase

    has_many :users, through: :users_edu_categories
    has_many :users_edu_categories

    has_many :questions, through: :questions_edu_categories
    has_many :questions_edu_categories
end
