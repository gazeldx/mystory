class Column < ActiveRecord::Base
  validates :name, :length => { :in => 1..25 }, :uniqueness => true
end
