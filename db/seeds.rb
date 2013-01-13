# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
#


users = User.create([{ :username => 'webmaster', :domain => 'webmaster', :email => 'webmaster@test.com', :name => 'Web Master', :passwd => Digest::SHA1.hexdigest('webmaster'), :memo => 'I am the Web Master! Please contact me!' }])
['Novels', 'Essays', 'Poems', 'Notes', 'Diaries', 'Stories', 'Books', 'Movies'].each do |name|
  Column.create(:name => name, :user => users.first)
end