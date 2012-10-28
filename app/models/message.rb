class Message < ActiveRecord::Base
  belongs_to :user
  validates :stype, :presence => true
  validates :body, :length => { :in => 1..2000 }
  validates :user_id, :presence => true
end