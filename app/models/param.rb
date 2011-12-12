class Param < ActiveRecord::Base
  belongs_to :user
  validates :sitename, :presence => true
  validates :memo, :presence => true
  validates :teldesc, :presence => true
  validates :user_id, :presence => true
  validates :user_id, :uniqueness => true
end
