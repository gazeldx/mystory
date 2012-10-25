class GcolumnsNotes < ActiveRecord::Base
  belongs_to :gcolumn
  belongs_to :note
  # attr_accessible :title, :body
end
