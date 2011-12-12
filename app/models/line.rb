class Line < ActiveRecord::Base
  belongs_to :user
  validates :title, :presence => true
  validates :content1, :presence => true
  validates :url1, :presence => true
  validates :content2, :presence => true
  validates :url2, :presence => true
  validates :content3, :presence => true
  validates :url3, :presence => true
  validates :user_id, :presence => true
  validates :user_id, :uniqueness => true
end