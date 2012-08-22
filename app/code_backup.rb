this.mouseOverImage = (id) ->
  src = $('#'+id+' img').attr('src')
  if src.indexOf('arrow2') > 0
    $('#'+id+' img').attr('src', '/images/arrow0.gif')
  else
    $('#'+id+' img').attr('src', '/images/arrow1.gif')

this.mouseOutImage = (id) ->
  src = $('#'+id+' img').attr('src')
  if src.indexOf('arrow1') > 0
    $('#'+id+' img').attr('src', '/images/arrow3.gif')
  else
    $('#'+id+' img').attr('src', '/images/arrow2.gif')

onmouseover="javascript:mouseOverImage('#{blog.id}')" onmouseout="javascript:mouseOutImage('#{blog.id}')"

regexp
tmp = something.content[0, size+150].gsub(/\r\n/,'&nbsp;').gsub(/<\/?.*?>/, "").gsub(/</, "")


div id='note-#{note.id}_full'
  == note.content
  - count = note.notecomments.size
  - if count > 0
    |
    = link_to t('comments_', w: count), note
  = recommend_etc note
  br

#alert $('#note_'+id+'_full').html()
    #alert $('#note_'+id+'_full').html() == 'nothing'
    #if $('#note_'+id+'_full').html() == 'nothing'
      $.ajax
        url: '/click_show_blog'
        data: "id=" + id
        dataType: "json",
        type: "GET"
        success: (d) ->
          #alert d['id']
          $('#note_'+id+'_full').html(htmlDecode(d['id']))

= summary_comment_style(blog, 4000)


        #,type: "GET"

- if @user.id == session[:id]
  - onmouseover = "$(this).find('.admin-lnks').css('display', '')"
  - onmouseout = "$(this).find('.admin-lnks').css('display', 'none')"
.comment-item onmouseover="#{onmouseover}" onmouseout="#{onmouseout}"

= hidden_field_tag :reply_user_id
.item
  = f.text_area :body, size: "64x4", class: 'comment'
  br
.item
  span.bn-flat-hot
    = f.submit t('submit')


#comments
  = render cc
= render 'shared/notice_error'
- if session[:id].nil?
  = t'comment_login_first'
- else
  h2
    span#who
      - if @comments_uids.include?(session[:id])
        = t'add_comment'
      - else
        = t'post_comment'
    |  &nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·
  = render '#{@clazz}comments/form'

javascript:
  $('#recommend').live('click', function() {
    recommend_note_in(#{@note.id});
  });

#comments
  = render "#{@clazz}comments/#{@clazz}comment"
= render 'shared/notice_error'
- if session[:id].nil?
  = t'comment_login_first'
- else
  h2
    span#who
      - if @comments_uids.include?(session[:id])
        = t'add_comment'
      - else
        = t'post_comment'
    |  &nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·&nbsp;·
  = render "#{@clazz}comments/form"
'notes' == controller_path

_side_user.html.slim
/= render 'shared/ad/user_side'
/= render 'shared/weibo_signature_2'
/coffee:
/  if screen.width>1024
/    $('#weibo_signature').html("<img border='0' src='http://service.t.sina.com.cn/widget/qmd/" + $('#weiboid').val() + "/1/1.png'/>")
