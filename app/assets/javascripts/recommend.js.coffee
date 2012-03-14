changeInButton = ->
  if $('#recommend').attr('class') == 'fav-cancel btn-fav'
    $('#recommend').html('推荐')
    $('#recommend').attr('title', '')
    $('#recommend').attr('class', 'fav-add btn-fav')
    $('#ri_body').html('')
    $('#edit').html('')
  else
    $('#recommend').html('已推荐')
    $('#recommend').attr('title', '点击可取消推荐')
    $('#recommend').attr('class', 'fav-cancel btn-fav')
    showBodyEtc()

this.showBodyEtc = ->
  $('#bodydiv').css 'display', ''
  $('#edit').css 'display', 'none'
  $('#body').val($('#ri_body').html())
  $('#ri_body').html('')
  $('#body').focus()
  #TODO why focus not work in firefox?

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
  $('#edit').html('<a onclick="showBodyEtc()" href="#edit">修改</a>')

this.recommend_blog = ->
  $.ajax
    url: '/recommend_blog'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      changeInButton()
      $('#ri_id').val(data['id'])

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
      $('#ri_id').val(data['id'])

this.recommend_note = (id) ->
  $.ajax
    url: '/recommend_note'
    data: "id=" + id
    type: "POST"
    success: ->
      if $('#recommend'+id).html() == '推荐'
        $('#recommend'+id).html('取消推荐')
      else
        $('#recommend'+id).html('推荐')

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

this.recommend_photo_in = (id) ->
  $.ajax
    url: '/recommend_photo'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      changeInButton()
      $('#ri_id').val(data['id'])