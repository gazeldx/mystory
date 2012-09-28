class GdomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[a-z][a-z\d\-]{1,17}[a-z\d]$/
      record.errors[attribute] << (options[:message])
    end
  end
end

class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :board
  mount_uploader :avatar, AvatarUploader
  
  validate :domain_not_used
  validates :domain, :uniqueness => true, :gdomain => true
  validates :name, :length => { :in => 1..25 }, :uniqueness => true

  def domain_not_used
    errors.add(:domain, "has been used! Please change it.") unless User.find_by_domain(domain).nil?
  end
end