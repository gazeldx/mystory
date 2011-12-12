class Client < ActiveRecord::Base
  validates :loginname, :presence => true
  validates :name, :presence => true
  validates :email, :presence => true
  validates :passwd, :presence => true
  validates :loginname, :uniqueness => true
  validates :email, :uniqueness => true
end
