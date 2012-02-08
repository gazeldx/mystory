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