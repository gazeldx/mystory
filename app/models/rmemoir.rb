class Rmemoir < ActiveRecord::Base
  belongs_to :user
  belongs_to :memoir

  validates :user_id, :presence => true
  validates :memoir_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :memoir_id}
end
