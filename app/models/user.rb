class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class User < ActiveRecord::Base
  has_many :news
  has_many :blogs
  has_many :notes
  has_many :categories
  has_many :menus
  has_one :portion
  has_one :line
  has_one :param
  validates :username, :uniqueness => true, :length => { :minimum => 5 }
  validates :name, :length => { :minimum => 2 }
  validates :email, :uniqueness => true, :length => { :minimum => 9 }, :email => true
  validates :domain, :uniqueness => true, :length => { :minimum => 4 }
  validates :passwd, :length => { :minimum => 6 }
end
