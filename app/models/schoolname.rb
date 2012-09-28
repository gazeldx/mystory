class Schoolname < ActiveRecord::Base
  belongs_to :group
  validates :name, :presence => true, :uniqueness => true
  validates :group_id, :presence => true
end