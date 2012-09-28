class Photocomment < ActiveRecord::Base
  belongs_to :photo
  belongs_to :user

  validates :photo_id, :presence => true
  validates :user_id, :presence => true
end
