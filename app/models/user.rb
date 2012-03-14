class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  has_many :categories, :dependent => :destroy
  has_many :blogs, :dependent => :destroy
  has_many :notes, :dependent => :destroy
  has_many :rblogs, :dependent => :destroy
  has_many :r_blogs, :through => :rblogs, :source => :blog
  has_many :rnotes, :dependent => :destroy
  has_many :r_notes, :through => :rnotes, :source => :note
  has_many :rphotos, :dependent => :destroy
  has_many :r_photos, :through => :rphotos, :source => :photo
  has_many :rhobbies, :dependent => :destroy
  has_many :hobbies, :through => :rhobbies
  has_many :ridols, :dependent => :destroy
  has_many :idols, :through => :ridols
  has_many :albums, :dependent => :destroy
  has_many :photos, :through => :albums
  has_one :customize

  acts_as_followable
  acts_as_follower

  validates :username, :uniqueness => true, :format => { :with => /^(?!_)(?!.*_$)\w{5,25}$/,
    :message => "Only letters and digital _ allowed" }
  validates :name, :length => { :in => 2..4 }
  validates :email, :uniqueness => true, :length => { :in => 9..36 }, :email => true
  validates :domain, :uniqueness => true, :length => { :in => 4..26 }
  validates :passwd, :length => { :in => 6..100 }
  validates :maxim, :length => { :in => 0..25 }
  validates :memo, :length => { :in => 0..100 }
end
