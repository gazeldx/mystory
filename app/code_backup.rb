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