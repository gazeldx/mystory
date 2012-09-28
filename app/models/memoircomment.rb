class Memoircomment < ActiveRecord::Base
  belongs_to :memoir
  belongs_to :user

  validates :memoir_id, :presence => true
  validates :user_id, :presence => true
end
