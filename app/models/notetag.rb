class Notetag < ActiveRecord::Base
  belongs_to :note
  validates :name, :presence => true
end
