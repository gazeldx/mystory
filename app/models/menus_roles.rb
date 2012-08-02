class MenusRoles < ActiveRecord::Base
  belongs_to :role
  belongs_to :menu
end
