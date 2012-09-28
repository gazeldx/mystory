class Menu < ActiveRecord::Base
  has_and_belongs_to_many :roles
  validates :code, :length => { :in => 1..40 }, :uniqueness => true
  validates :name, :length => { :in => 1..25 }, :uniqueness => true
end
