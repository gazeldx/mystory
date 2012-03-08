class Note < ActiveRecord::Base
  belongs_to :user
  has_many :notecomments, :dependent => :destroy
  has_many :rnotes, :dependent => :destroy

  validates :title, :length => { :in => 0..40 }
  validates :content, :length => { :in => 1..3000 }
  validates :user_id, :presence => true
  self.per_page = 10
end