class Gcolumn < ActiveRecord::Base
  belongs_to :group
  has_and_belongs_to_many :blogs
  has_and_belongs_to_many :notes
  validates :group_id, :presence => true
  validates :name, :length => { :in => 1..25 }, :uniqueness => {:scope => :group_id}
  #  attr_accessible :name
  
  before_create :set_default_time_to_now
  def set_default_time_to_now
    self.created_at = Time.now
  end
end
