class Board < ActiveRecord::Base
  has_many :posts
  validates :name, :length => { :in => 1..25 }, :uniqueness => true
end
