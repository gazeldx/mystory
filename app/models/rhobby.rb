class Rhobby < ActiveRecord::Base
  belongs_to :user
  belongs_to :hobby
  validates :user_id, :presence => true
  validates :hobby_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :hobby_id}
end
