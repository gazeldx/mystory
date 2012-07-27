class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class DomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[a-z][a-z\d\-]{2,17}[a-z\d]$/
      record.errors[attribute] << (options[:message])
    end
  end
end

class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  has_many :categories, :dependent => :destroy
  has_many :notecates, :dependent => :destroy
  has_many :assortments, :dependent => :destroy
  has_many :blogs, :dependent => :destroy
  has_many :blogcomments, :dependent => :destroy
  has_many :tags, :through => :blogs, :source => :tags
  has_many :notes, :dependent => :destroy
  has_many :notecomments, :dependent => :destroy
  has_many :notetags, :through => :notes, :source => :notetags
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
  has_many :renjoys, :dependent => :destroy
  has_many :enjoys, :through => :renjoys
  has_many :albums, :dependent => :destroy
  has_many :photos, :through => :albums
  has_many :photocomments, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :postcomments, :dependent => :destroy
  has_many :fboards, :dependent => :destroy
#  has_many :f_boards, :through => :fboards, :source => :board
  has_one :memoir
  has_one :customize

  has_many :letters, :dependent => :destroy#sent letters
  has_many :received_letters, :class_name => 'Letter', :foreign_key => 'recipient_id', :dependent => :destroy

  acts_as_followable
  acts_as_follower

  validates :username, :uniqueness => true, :format => { :with => /^(?!_)(?!.*_$)\w{4,25}$/ }
  validates :email, :uniqueness => true, :length => { :in => 9..36 }, :email => true
  validates :domain, :uniqueness => true, :domain => true
  #  , :format => { :with => /^[a-z][a-z\d\-]{1,17}[a-z\d]$/ }
  validates :name, :length => { :in => 2..16 }
  validates :passwd, :length => { :in => 6..100 }
  validates :maxim, :length => { :in => 0..25 }
  validates :memo, :length => { :in => 0..100 }
  validates :signature, :length => { :in => 0..300 }
end
