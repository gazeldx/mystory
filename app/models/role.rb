class Role < ActiveRecord::Base
  has_and_belongs_to_many :menus
  has_and_belongs_to_many :users
  validates :name, :length => { :in => 1..25 }, :uniqueness => true
end
