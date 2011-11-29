class Portion < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :uniqueness => true
end
