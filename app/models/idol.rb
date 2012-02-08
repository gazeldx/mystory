class Idol < ActiveRecord::Base
  has_many :ridols, :dependent => :destroy
  has_many :users, :through => :ridols
  validates :name, :presence => true, :uniqueness => true
end
