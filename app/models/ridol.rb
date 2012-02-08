class Ridol < ActiveRecord::Base
  belongs_to :user
  belongs_to :idol
  validates :user_id, :presence => true
  validates :idol_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :idol_id}
end
