class Blog < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :blogcomments, :dependent => :destroy
  has_many :rblogs, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  has_many :tracemaps, :dependent => :destroy

  validates :title, :length => { :in => 1..80 }
  validates :content, :length => { :in => 1..1000000 }
  validates :category_id, :presence => true
  validates :user_id, :presence => true
  accepts_nested_attributes_for :tags, :allow_destroy => :true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  self.per_page = 20
end
