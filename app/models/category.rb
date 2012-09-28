class Category < ActiveRecord::Base
  has_many :blogs
  belongs_to :user
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true
end
