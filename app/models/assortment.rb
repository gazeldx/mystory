class Assortment < ActiveRecord::Base
  has_many :rblogs
  belongs_to :user
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true
end
