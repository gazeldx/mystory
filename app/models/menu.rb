class Menu < ActiveRecord::Base
  belongs_to :user
  validates :name, :presence => true
  validates :url, :presence => true
  validates :user_id, :presence => true
end
