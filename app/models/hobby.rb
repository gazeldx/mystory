class Hobby < ActiveRecord::Base
  has_many :rhobbies, :dependent => :destroy
  has_many :users, :through => :rhobbies
  validates :name, :presence => true, :uniqueness => true
end
