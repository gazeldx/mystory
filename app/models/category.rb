class Category < ActiveRecord::Base
  has_many :news
  has_many :blogs
  belongs_to :user
  validates :name, :presence => true
  validates :user_id, :presence => true
  validates :name, :uniqueness => true
end
