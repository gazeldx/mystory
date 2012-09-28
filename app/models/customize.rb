class Customize < ActiveRecord::Base
  belongs_to :user
  mount_uploader :bgimage, BgimageUploader

  validates :user_id, :uniqueness => true
end
