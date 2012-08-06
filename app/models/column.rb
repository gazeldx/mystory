class Column < ActiveRecord::Base
  has_and_belongs_to_many :blogs
  validates :name, :length => { :in => 1..25 }, :uniqueness => true
end
