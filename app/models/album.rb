class Album < ActiveRecord::Base
  belongs_to :user
  #TODO user.html.slim @user.photos is not all photos but show me only all covers.Why?
  belongs_to :photo
  #TODO HOW TO DELETE USER upyun PHOTOS?
  has_many :photos, :dependent => :destroy
  

  validates :name, :length => { :in => 1..20 }
  validates :description, :length => { :maximum => 300 }
  validates :user_id, :presence => true
end