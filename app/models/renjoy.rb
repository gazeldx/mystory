class Renjoy < ActiveRecord::Base
  belongs_to :user
  belongs_to :enjoy
  validates :user_id, :presence => true
  validates :enjoy_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :enjoy_id}
end
