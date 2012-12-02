class SocietiesController < ApplicationController
  layout 'help'
  before_filter :super_admin
end
