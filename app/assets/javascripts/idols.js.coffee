this.add_idol = ->
  $.ajax
    url: '/idols/create'
    data: "name=" + $('#idol_name').val()
    type: "POST"
    success: ->
      $('#notice').html('添加成功!')