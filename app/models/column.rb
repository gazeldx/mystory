class Column < ActiveRecord::Base
  has_and_belongs_to_many :blogs
  has_and_belongs_to_many :notes
  validates :name, :length => { :in => 1..25 }, :uniqueness => true
end
