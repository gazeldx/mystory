this.showBlog = (id) ->
  src = $('#'+id+' img').attr('src')
  if src.indexOf('arrow2') > 0
    $('#'+id+' img').attr('src', '/images/arrow3.gif')
    $('#'+id).attr('title', '收起文章')
    $('#note_'+id+'_short').css 'display', 'none'
    if $('#note_'+id+'_full').html() == ''
      $.ajax
        url: '/click_show_blog'
        data: "id=" + id
        dataType: "json"
        success: (d) ->
          $('#note_'+id+'_full').html(d['content'])
    $('#note_'+id+'_full').css 'display', ''
    $('#note_'+id+'_full2').css 'display', ''
  else
    $('#'+id+' img').attr('src', '/images/arrow2.gif')
    $('#'+id).attr('title', '展开文章')
    $('#note_'+id+'_short').css 'display', ''
    $('#note_'+id+'_full').css 'display', 'none'
    $('#note_'+id+'_full2').css 'display', 'none'

this.showNote = (id) ->
  src = $('#'+id+' img').attr('src')
  if src.indexOf('arrow2') > 0
    $('#'+id+' img').attr('src', '/images/arrow3.gif')
    $('#'+id).attr('title', '收起文章')
    $('#note_'+id+'_short').css 'display', 'none'
    if $('#note_'+id+'_full').html() == ''
      $.ajax
        url: '/click_show_note'
        data: "id=" + id
        dataType: "json"
        success: (d) ->
          $('#note_'+id+'_full').html(d['content'])
    $('#note_'+id+'_full').css 'display', ''
    $('#note_'+id+'_full2').css 'display', ''
  else
    $('#'+id+' img').attr('src', '/images/arrow2.gif')
    $('#'+id).attr('title', '展开文章')
    $('#note_'+id+'_short').css 'display', ''
    $('#note_'+id+'_full').css 'display', 'none'
    $('#note_'+id+'_full2').css 'display', 'none'

this.switchView = ->
  if $('#view').val() != '0'
    $('.note').css 'display', 'none'
    $('.note_full').css 'display', 'none'
    $('#view').val '0'
  else
    $('.note').css 'display', ''
    $('.note_full').css 'display', 'none'
    $('#view').val '1'

this.like_blog_comment = (id) ->
  $.ajax
    url: '/like_blog_comment'
    data: "id=" + id
    type: "POST"
    dataType: "json"
    success: (d) ->
      if $('#like'+id).html()=='赞'
        $('#like'+id).html '已赞'
      else
        $('#like'+id).html '赞'
      $('#like_count'+id).html d['likecount']

this.like_note_comment = (id) ->
  $.ajax
    url: '/like_note_comment'
    data: "id=" + id
    type: "POST"
    dataType: "json"
    success: (d) ->
      if $('#like'+id).html()=='赞'
        $('#like'+id).html '已赞'
      else
        $('#like'+id).html '赞'
      $('#like_count'+id).html d['likecount']

this.like_memoir_comment = (id) ->
  $.ajax
    url: '/like_memoir_comment'
    data: "id=" + id
    type: "POST"
    dataType: "json"
    success: (d) ->
      if $('#like'+id).html()=='赞'
        $('#like'+id).html '已赞'
      else
        $('#like'+id).html '赞'
      $('#like_count'+id).html d['likecount']