class Blogcomment < ActiveRecord::Base
  belongs_to :blog
  belongs_to :user

  validates :blog_id, :presence => true
  validates :user_id, :presence => true
end
