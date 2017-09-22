class UsersEduCategory < ActiveRecord::Base
    belongs_to :user, foreign_key: :user_id
    belongs_to :edu_category, foreign_key: :edu_category_id
end
