class GroupsUsers < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :user_id, :presence => true
  validates :group_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :group_id}

  before_create :set_default_time_to_now
  def set_default_time_to_now
    self.created_at = Time.now
  end
end