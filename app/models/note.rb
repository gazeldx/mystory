class Note < ActiveRecord::Base
  has_and_belongs_to_many :columns
  has_and_belongs_to_many :gcolumns
  belongs_to :notecate
  belongs_to :user
  has_many :notecomments, :dependent => :destroy
  has_many :rnotes, :dependent => :destroy
  has_many :notetags, :dependent => :destroy

  validates :title, :length => { :in => 0..80 }
  validates :content, :length => { :in => 1..30000 }
  validates :notecate_id, :presence => true
  validates :user_id, :presence => true
  self.per_page = 20

  scope :visible, where(:is_draft => false).order('created_at desc')
  
  def tags
    notetags
  end

  include Markdown
end