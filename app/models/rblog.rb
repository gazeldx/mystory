class Rblog < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog
  validates :user_id, :presence => true
  validates :blog_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :blog_id}
end
