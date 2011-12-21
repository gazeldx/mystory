class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end


class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  has_many :news
  has_many :blogs
  has_many :notes
  has_many :categories

  acts_as_followable
  acts_as_follower
#  has_many :following, :through => :follows, :source => "followed_id"
#  has_many :followers, :through => :follows, :source => "follower_id"
#  has_many :follows, :foreign_key => "follower_id", :dependent => :destroy
  validates :username, :uniqueness => true, :length => { :minimum => 5 }
  validates :name, :length => { :minimum => 2 }
  validates :email, :uniqueness => true, :length => { :minimum => 9 }, :email => true
  validates :domain, :uniqueness => true, :length => { :minimum => 4 }
  validates :passwd, :length => { :minimum => 6 }
end
