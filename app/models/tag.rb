class Tag < ActiveRecord::Base
  belongs_to :blog
  validates :name, :presence => true
end
