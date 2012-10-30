class Gad < ActiveRecord::Base
  belongs_to :group
  mount_uploader :avatar, GadUploader
end
