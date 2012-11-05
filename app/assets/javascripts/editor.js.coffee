this.show_editor_columns = ->
  query_user_columns()
  $('#editor_columns').css 'display', ''
  
this.query_user_columns = ->
  $.ajax
    url: '/query_user_columns'
    success: (data) ->
      html = "收编到：#{data}"
      $('#columns_box').html html  

this.editor_note = (id) ->
  $.ajax
    url: '/editor_note'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      change_show_content(id, data, 'note')

this.editor_blog = (id) ->
  $.ajax
    url: '/editor_blog'
    data: "id=" + id
    type: "POST"
    success: (data) ->
      change_show_content(id, data, 'blog')

change_show_content = (id, data, type) ->
  $("#editor_#{type}_tip_"+id).html "收编成功"