class Notecomment < ActiveRecord::Base
  belongs_to :note
  belongs_to :user

  validates :note_id, :presence => true
  validates :user_id, :presence => true
end
