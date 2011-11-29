class User < ActiveRecord::Base
  has_many :news
  has_many :categories
  has_one :portion
  validates :username, :presence => true
  validates :name, :presence => true
  validates :email, :presence => true
  validates :passwd, :presence => true
  validates :username, :uniqueness => true
  validates :email, :uniqueness => true
end
