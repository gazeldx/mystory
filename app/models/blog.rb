class Blog < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :blogcomments, :dependent => :destroy
  has_many :rblogs, :dependent => :destroy

  validates :title, :length => { :in => 1..40 }
  validates :content, :presence => true
  validates :category_id, :presence => true
  validates :user_id, :presence => true
  self.per_page = 10
end
