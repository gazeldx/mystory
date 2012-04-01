class Note < ActiveRecord::Base
  belongs_to :notecate
  belongs_to :user
  has_many :notecomments, :dependent => :destroy
  has_many :rnotes, :dependent => :destroy
  has_many :notetags, :dependent => :destroy

  validates :title, :length => { :in => 0..60 }
  validates :content, :length => { :in => 1..10000 }
  validates :notecate_id, :presence => true
  validates :user_id, :presence => true
  self.per_page = 20
end