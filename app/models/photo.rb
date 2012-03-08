require 'file_size_validator'
class Photo < ActiveRecord::Base
  mount_uploader :avatar, PhotoUploader
  belongs_to :album
  #TODO WHY :file_size IS NOT work right?  1.megabytes can support 5.6M
  validates :avatar, :presence => true, :file_size => {:maximum => 1.megabytes.to_i}
  validates :album_id, :presence => true
end
