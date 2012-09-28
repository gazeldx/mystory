class Enjoy < ActiveRecord::Base
  has_many :renjoys, :dependent => :destroy
  has_many :users, :through => :renjoys
  validates :name, :presence => true
  validates :stype, :presence => true
  validates :name, :uniqueness => {:scope => :stype}
end
