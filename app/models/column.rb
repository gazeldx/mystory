class Column < ActiveRecord::Base
  has_and_belongs_to_many :blogs
  has_and_belongs_to_many :notes
  belongs_to :user
  validates :name, :length => { :in => 1..25 }, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true
end
