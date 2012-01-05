class Blog < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  validates :title, :presence => true
  validates :content, :presence => true
  validates :category_id, :presence => true
  validates :user_id, :presence => true
  self.per_page = 10
end
