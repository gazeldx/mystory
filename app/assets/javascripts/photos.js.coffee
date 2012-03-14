this.showDescEtc = ->
  $('#editDiv').css 'display', ''
  $('#description').focus()

successProc = ->
  $('#editDiv').css 'display', 'none'
  $('#photo_desc').html($('#description').val())
  $('#notice2').html('修改成功!')

this.modify_photo = (photo_id) ->
  $.ajax
    url: '/photos/modify'
    data: "id=" + photo_id + "&photo[description]=" + $('#description').val() + "&setascover=" + $(':radio:checked').val()
    type: "POST"
    success: ->
      successProc()

this.showAlbums = (albums_url) ->
  $('#i_s_a').attr 'src', albums_url
  $('#dui-dialog0').css 'display', ''

this.hiddenAlbums = (albums_url) ->
  $('#i_s_a').attr 'src', albums_url
  $('#dui-dialog0').css 'display', 'none'

this.selectPhoto = (photo_id, albums_url) ->
  p = window.parent.document
  n_t = $('#note_text', p)
  n_t.val(n_t.val() + '+photo' + photo_id + '+\n')

  $('#i_s_a', p).attr 'src', albums_url
  $('#dui-dialog0', p).css 'display', 'none'

this.switchPhoto = (id, img_url, img_thumb_url) ->
  if ($('#'+id).attr 'title')=="点击放大"
    $('#'+id+' img').attr('src', img_url)
    $('#'+id).attr 'title', "点击缩小"
  else
    $('#'+id+' img').attr('src', img_thumb_url)
    $('#'+id).attr 'title', "点击放大"