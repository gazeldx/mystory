class Notecate < ActiveRecord::Base
  has_many :notes
  belongs_to :user
  validates :name, :length => { :in => 1..25 }, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true
end
