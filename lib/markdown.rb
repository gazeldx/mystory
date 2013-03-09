module Markdown
  extend ActiveSupport::Concern

  module InstanceMethods
    def md_content
      GitHub::Markdown.to_html(content, :gfm)
    end

    def markdown?
      content.match(/markdown/i) != nil
    end
  end

  module ClassMethods
    # Nothing
  end
end