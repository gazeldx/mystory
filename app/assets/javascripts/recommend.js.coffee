changeInButton = ->
  if $('#recommend').attr('class') == 'fav-cancel btn-fav'
    $('#recommend').html('推荐')
    $('#recommend').attr('title', '')
    $('#recommend').attr('class', 'fav-add btn-fav')
    $('#r_count').html("#{$('#r_count').html().match(/\d+/)-1}人推荐")
    #$('#ri_body').html('')
    #$('#edit').html('')
  else
    $('#recommend').html('已推荐')
    $('#recommend').attr('title', '点击可取消推荐')
    $('#recommend').attr('class', 'fav-cancel btn-fav')
    $('#r_count').html("#{(parseInt($('#r_count').html().match(/\d+/))||0) + 1}人推荐")
    #showBodyEtc()

this.showBodyEtc = ->
  $('#bodydiv').css 'display', ''
  $('#edit').css 'display', 'none'
  $('#body').val($('#ri_body').html())
  $('#ri_body').html('')
  $('#body').focus()

this.modify_ri = (t) ->
  $.ajax
    url: '/recommend/modify_' + t
    data: "id=" + $('#ri_id').val() + "&ri[body]=" + $('#body').val()
    type: "POST"
    success: (data) ->
      modify_ri_succ()
      #$('#ri_id').val(data['id'])

modify_ri_succ = ->
  $('#bodydiv').css 'display', 'none'
  $('#ri_body').html($('#body').val())
  $('#edit').css 'display', ''
  $('#edit').html('<a onclick="showBodyEtc()" href="javascript:;">修改</a>')

this.cancel_recommend_blog = (id) ->
  $.ajax
    url: '/recommend_blog'
    data: "id=" + id
    type: "POST"
    success: ->
      _li = $('#recommend-blog'+id).closest('li')
      p_li = $('#recommend-blog'+id).closest('li').prev()
      _li.css 'display', 'none'
      p_li.css 'display', 'none'

this.recommend_note_in = (id) ->
  $.ajax
    url: '/recommend_note'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      changeInButton()

this.recommend_blog_in = (id) ->
  $.ajax
    url: '/recommend_blog'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      changeInButton()

this.recommend_note = (id) ->
  $.ajax
    url: '/recommend_note'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      change_show_content(id, data, 'note')

this.recommend_blog = (id) ->
  $.ajax
    url: '/recommend_blog'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      change_show_content(id, data, 'blog')

this.recommend_memoir = (id) ->
  $.ajax
    url: '/recommend_memoir'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      change_show_content(id, data, 'memoir')

this.cancel_recommend_note = (id) ->
  $.ajax
    url: '/recommend_note'
    data: "id=" + id
    type: "POST"
    success: ->
      _li = $('#recommend'+id).closest('li')
      p_li = $('#recommend'+id).closest('li').prev()
      _li.css 'display', 'none'
      p_li.css 'display', 'none'

this.recommend_photo = (id) ->
  $.ajax
    url: '/recommend_photo'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      change_show_content(id, data, 'photo')

this.cancel_recommend_photo = (id) ->
  $.ajax
    url: '/recommend_photo'
    data: "id=" + id
    type: "POST"
    success: ->
      _li = $('#recommend'+id).closest('li')
      p_li = $('#recommend'+id).closest('li').prev()
      _li.css 'display', 'none'
      p_li.css 'display', 'none'

this.recommend_photo_in = (id) ->
  $.ajax
    url: '/recommend_photo'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      changeInButton()

this.recommend_memoir_in = (id) ->
  $.ajax
    url: '/recommend_memoir'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      changeInButton()

change_show_content = (id, data, type) ->
  $("#recommend_#{type}_"+id).html "推荐(#{data['recommend_count']})"