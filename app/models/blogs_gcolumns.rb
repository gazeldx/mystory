class BlogsGcolumns < ActiveRecord::Base
  belongs_to :gcolumn
  belongs_to :blog
  # attr_accessible :title, :body
end
