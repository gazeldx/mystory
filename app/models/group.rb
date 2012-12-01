class GdomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[a-z][a-z\d\-]{1,17}[a-z\d]$/
      record.errors[attribute] << (options[:message])
    end
  end
end

class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :groups_userss, :dependent => :destroy
  has_many :gcolumns, :dependent => :destroy
  has_many :gads, :dependent => :destroy
  has_many :notes, :through => :gcolumns
  has_many :blogs, :through => :gcolumns
  has_many :chats, :dependent => :destroy
  belongs_to :board
  mount_uploader :avatar, AvatarUploader
  
  validate :domain_not_used
  validates :domain, :uniqueness => true, :gdomain => true
  validates :name, :length => { :in => 1..18 }, :uniqueness => true
  validates :maxim, :length => { :in => 0..25 }
  validates :memo, :length => { :in => 0..99999 }

  def domain_not_used
    errors.add(:domain, "has been used! Please change it.") unless User.find_by_domain(domain).nil?
  end

  def member? user_id
    groups_userss.detect{ |i| i.user_id == user_id.to_i } unless user_id.nil?
  end
end