class Post < ActiveRecord::Base
  belongs_to :board
  belongs_to :user
  has_many :postcomments, :dependent => :destroy
  
  validates :title, :length => { :in => 1..60 }
  validates :content, :length => { :in => 0..100000 }
  validates :board_id, :presence => true
  validates :user_id, :presence => true
#  accepts_nested_attributes_for :tags, :allow_destroy => :true,
#    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
#  self.per_page = 20
end
