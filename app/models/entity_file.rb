class EntityFile < ActiveRecord::Base
    mount_uploader :file, EntityFileUploader
    belongs_to :user
end
