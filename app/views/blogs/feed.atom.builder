atom_feed :language => 'zh-CN' do |feed|
  feed.title "#{@user.name}_#{t'site.name'}"
  feed.updated @all.first.updated_at unless @all.empty?

  @all.each do |item|
    # next if item.updated_at.blank?
    feed.entry(item) do |entry|
      entry.url eval("#{item.class.name.downcase}_url(item)")
      entry.title item.title
      entry.content style_it_no_blank(item.content), :type => 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name @user.name
      end
    end
  end
end
