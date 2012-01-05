class Note < ActiveRecord::Base
  belongs_to :user

  validates :content, :presence => true
  validates :user_id, :presence => true
  self.per_page = 10
end