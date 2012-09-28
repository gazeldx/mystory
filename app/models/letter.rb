class Letter < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipient, :class_name => "User"

  validates :body, :length => { :in => 1..500 }
  validates :user_id, :presence => true
  validates :recipient_id, :presence => true
#  has_one :sender, :class_name => "User"
#  has_one :recipient, :class_name => "User"
end
