this.like_post_comment = (id) ->
  $.ajax
    url: '/like_post_comment'
    data: "id=" + id
    type: "POST"
    dataType: "json"
    success: (d) ->
      if $('#like'+id).html()=='赞'
        $('#like'+id).html '已赞'
      else
        $('#like'+id).html '赞'
      $('#like_count'+id).html d['likecount']