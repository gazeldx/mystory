class BlogsColumns < ActiveRecord::Base  
  belongs_to :column
  belongs_to :blog
end
