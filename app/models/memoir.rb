class Memoir < ActiveRecord::Base
  belongs_to :user
  has_many :memoircomments, :dependent => :destroy
  has_many :rmemoirs, :dependent => :destroy

  validates :title, :length => { :in => 0..160 }
  validates :content, :length => { :in => 1..1000000 }
  validates :user_id, :presence => true
end
