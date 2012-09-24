class GroupsUsers < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :user_id, :presence => true
  validates :group_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :group_id}
end
