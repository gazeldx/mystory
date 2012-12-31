this.show_editor_columns = ->
  if $('#editor_columns').css('display') == 'none'
    $.ajax
      url: '/query_user_columns'
      data: "id=" + $('#article_id').val() + "&stype=" + $('#stype').val()
      success: (data) ->
        $('#columns_box').html data
    $('#editor_columns').css 'display', ''
  else
    $('#editor_columns').css 'display', 'none'

this.update_user_columns = ->
  columns = []
  $('#editor_columns :checked').each ->
    columns.push($(this).val())
  $.ajax
    url: '/update_user_columns'
    data: "id=" + $('#article_id').val() + "&columns=#{columns}" + "&stype=" + $('#stype').val()
    type: "POST"
    success: (r) ->
      $('#ctips').html '收藏成功！'
      $("#columns_count").html "(#{r})"

this.show_article_editors = ->
  if $('#article_editors').css('display') == 'none'
    $.ajax
      url: '/query_article_editors'
      data: "id=" + $('#article_id').val() + "&stype=" + $('#stype').val()
      success: (data) ->
        $('#editors_box').html data
    $('#article_editors').css 'display', ''
  else
    $('#article_editors').css 'display', 'none'