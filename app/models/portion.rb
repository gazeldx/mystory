class Portion < ActiveRecord::Base
  belongs_to :user
  validates :title, :presence => true
  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :user_id, :uniqueness => true
end
