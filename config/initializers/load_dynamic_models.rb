["blog", "memoir", "note", "photo", "post"].each do |name|
  Object.const_set("#{name}comment".capitalize.to_sym,
    Class.new(ActiveRecord::Base) {
      belongs_to name.to_sym
      belongs_to :user
      validates "#{name}_id".to_sym, :presence => true
      validates :user_id, :presence => true
    }
  )
end

require 'markdown'