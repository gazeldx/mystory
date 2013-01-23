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
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :groups
  has_many :menus, :through => :roles, :source => :menus
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
  has_one :memoir, :dependent => :destroy
  has_many :memoircomments, :dependent => :destroy
  has_one :customize, :dependent => :destroy

  has_many :letters, :dependent => :destroy#sent letters
  has_many :received_letters, :class_name => 'Letter', :foreign_key => 'recipient_id', :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :columns, :dependent => :destroy
#  has_many :blogs_columnses, :through => :columns, :source => :blogs_columns
#  has_many :notes_columnses, :through => :columns, :source => :notes_columns
#  has_many :c_blogs, :through => :blogs_columnses, :source => :blog
#  has_many :c_notes, :through => :notes_columnses, :source => :note

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
  validates :source, :presence => true
  validate :domain_not_used

  def weibo_active?
    Settings[:weibo] and self.weiboid
  end

  def enjoy_books
    renjoys.includes(:enjoy).where("enjoys.stype = 1").order('renjoys.created_at')
  end

  def enjoy_musics
    renjoys.includes(:enjoy).where("enjoys.stype = 2").order('renjoys.created_at')
  end

  def enjoy_movies
    renjoys.includes(:enjoy).where("enjoys.stype = 3").order('renjoys.created_at')
  end
  
  def domain_not_used
    errors.add(:domain, "has been used! Please change it.") unless Group.find_by_domain(domain).nil?
  end

  # Just fix the little bug which no default view_letters_at when send letter.If not see letters will see the bug.
  #http://stackoverflow.com/questions/1580805/how-to-set-the-default-value-for-a-datetime-column-in-migration-script
  #  t.datetime :starts_at, :null => false, :default => Time.now
  before_create :set_default_time_to_now
  def set_default_time_to_now
    self.view_comments_at = Time.now
    self.view_commented_at = Time.now
    self.view_letters_at = Time.now
    self.view_messages_at = Time.now
  end
end