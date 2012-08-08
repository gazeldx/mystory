class ColumnsNotes < ActiveRecord::Base
  belongs_to :column
  belongs_to :note
end
