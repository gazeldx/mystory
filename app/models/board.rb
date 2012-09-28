class Board < ActiveRecord::Base
  has_many :posts
  has_one :group
  validates :name, :length => { :in => 1..25 }, :uniqueness => true
end
