- @blogs.each do |blog|
        %li.mbtl
          %a{:href => site(blog.user), :target => '_blank'}
            /= image_tag(blog.user.avatar.thumb.url)
            = render 'test'
        %li.mbtr
          = link_to blog.user.name, site(blog.user), :target => '_blank'
          %span.pl
            发表作品
            = link_to blog.title, site(blog.user) + blog_path(blog), :target => '_blank'
          /.quote
          %span.inq
            = summary(blog.content, 200)


/%label{:display => 'block'}
          /TODO 说点什么吧
          /%textarea{:rows => "1", :name => "comment", :style => "height: 36px;"}

            <h1>欢迎，</h1> session[:name]


.span-7.last
  %h3
    #{@user.name}关注的人
  /TODO UNION NOTES and blogs and show together
  %h3= t'_note'
  - @notes.each do |note|
    = link_to note.user.name, site(note.user)
    = (note.created_at + 8.hour).strftime '%m月%d日 %H:%M'
    %br
    - if note.content.size > 160
      = note.content[0,140]
      = link_to '>>', note
    - else
      = note.content[0,140]
    %br
  %h3= t'_blog'
  - @blogs.each do |blog|
    = link_to blog.user.name, site(blog.user)
    = link_to blog.title, site(blog.user) + blog_path(blog)
    = (blog.created_at + 8.hour).strftime '%m月%d日 %H:%M'
    %br


#puts /^(?!_)(?!.*_$)\w{2,500}$/ =~ "ss"
puts /\w{2,5}$/ =~ "sgddfddsd"


ku = [5,2,"justin",]
puts ku